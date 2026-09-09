<?php
declare(strict_types=1);

/**
 * Role-specific portal features.
 * This controller handles personal profiles, teacher-only section access, and
 * student receipt submissions. Payment balances change only after review.
 */
function handle_user_features(string $action,string $method,array $data): void {
    if(!in_array($action,['profile_get','profile_save','teacher_sections','teacher_section_detail','payment_submit','payment_list','payment_receipt','payment_process'],true))return;
    global $config;
    $u=require_auth();$pdo=db();

    // Profile reads use application data for students and user_profiles for staff accounts.
    if($action==='profile_get'){
        if($u['role_name']==='Student'){
            $q=$pdo->prepare("SELECT u.id user_id,u.username,u.email,u.status,r.role_name,a.first_name,a.middle_name,a.last_name,a.birth_date,a.contact_number,a.present_address,a.last_school_attended,a.lrn,a.strand,a.year_graduated,sp.student_number,sp.section_id,p.program_code,p.program_name,se.section_name,se.year_level,se.school_year,se.semester FROM users u JOIN roles r ON r.id=u.role_id JOIN student_profiles sp ON sp.user_id=u.id JOIN applications a ON a.id=sp.application_id JOIN programs p ON p.id=sp.program_id LEFT JOIN sections se ON se.id=sp.section_id WHERE u.id=?");
        }else{
            $q=$pdo->prepare("SELECT u.id user_id,u.username,u.email,u.status,r.role_name,up.first_name,up.middle_name,up.last_name,up.birth_date,up.contact_number,up.present_address FROM users u JOIN roles r ON r.id=u.role_id LEFT JOIN user_profiles up ON up.user_id=u.id WHERE u.id=?");
        }
        $q->execute([$u['id']]);$profile=$q->fetch();if(!$profile)respond(['success'=>false,'error'=>'Profile record not found.'],404);if($u['role_name']==='Student')$profile['schedule']=$profile['section_id']?schedule((int)$profile['section_id']):[];respond(['success'=>true,'data'=>$profile]);
    }

    if($action==='profile_save'){
        if($method!=='POST')respond(['success'=>false,'error'=>'Method not allowed.'],405);csrf_check();
        $first=trim((string)($data['first_name']??''));$middle=trim((string)($data['middle_name']??''));$last=trim((string)($data['last_name']??''));$contact=trim((string)($data['contact_number']??''));$address=trim((string)($data['present_address']??''));$birth=trim((string)($data['birth_date']??''));
        if($first===''||$last===''||strlen($first)>100||strlen($last)>100)respond(['success'=>false,'error'=>'First name and last name are required.'],422);
        $pdo->beginTransaction();
        if($u['role_name']==='Student'){
            $q=$pdo->prepare('UPDATE applications a JOIN student_profiles sp ON sp.application_id=a.id SET a.first_name=?,a.middle_name=?,a.last_name=?,a.birth_date=?,a.contact_number=?,a.present_address=? WHERE sp.user_id=?');
            $q->execute([$first,$middle?:null,$last,$birth?:null,$contact?:null,$address?:null,$u['id']]);
        }else{
            $q=$pdo->prepare('INSERT INTO user_profiles(user_id,first_name,middle_name,last_name,birth_date,contact_number,present_address) VALUES(?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE first_name=VALUES(first_name),middle_name=VALUES(middle_name),last_name=VALUES(last_name),birth_date=VALUES(birth_date),contact_number=VALUES(contact_number),present_address=VALUES(present_address)');
            $q->execute([$u['id'],$first,$middle?:null,$last,$birth?:null,$contact?:null,$address?:null]);
        }
        $pdo->commit();audit('profile.update','users',$u['id']);respond(['success'=>true,'data'=>['updated'=>true]]);
    }

    // Teachers can query only sections recorded in teacher_sections for their user ID.
    if($action==='teacher_sections'||$action==='teacher_section_detail'){
        require_auth(['Teacher']);
        if($action==='teacher_sections'){
            $q=$pdo->prepare("SELECT se.id,se.section_name,se.year_level,se.school_year,se.semester,se.capacity,p.program_code,p.program_name,(SELECT COUNT(*) FROM student_profiles sp WHERE sp.section_id=se.id AND sp.is_active=1) student_count FROM teacher_sections ts JOIN sections se ON se.id=ts.section_id JOIN programs p ON p.id=se.program_id WHERE ts.teacher_user_id=? ORDER BY se.section_name");$q->execute([$u['id']]);respond(['success'=>true,'data'=>$q->fetchAll()]);
        }
        $id=(int)($_GET['id']??0);$q=$pdo->prepare('SELECT se.*,p.program_code,p.program_name FROM teacher_sections ts JOIN sections se ON se.id=ts.section_id JOIN programs p ON p.id=se.program_id WHERE ts.teacher_user_id=? AND se.id=?');$q->execute([$u['id'],$id]);$section=$q->fetch();if(!$section)respond(['success'=>false,'error'=>'This section is not assigned to you.'],403);
        $q=$pdo->prepare("SELECT sp.student_number,CONCAT(a.last_name,', ',a.first_name) student_name,a.email,a.contact_number FROM student_profiles sp JOIN applications a ON a.id=sp.application_id WHERE sp.section_id=? AND sp.is_active=1 ORDER BY a.last_name,a.first_name");$q->execute([$id]);$students=$q->fetchAll();
        $q=$pdo->prepare("SELECT su.subject_code,su.subject_name,su.units,sc.day_of_week,TIME_FORMAT(sc.start_time,'%h:%i %p') start_time,TIME_FORMAT(sc.end_time,'%h:%i %p') end_time,sc.room,sc.instructor FROM class_schedules sc JOIN subjects su ON su.id=sc.subject_id JOIN users tu ON tu.id=sc.teacher_user_id AND tu.status='active' JOIN roles tr ON tr.id=tu.role_id AND tr.role_name='Teacher' WHERE sc.section_id=? ORDER BY FIELD(sc.day_of_week,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'),sc.start_time");$q->execute([$id]);respond(['success'=>true,'data'=>['section'=>$section,'students'=>$students,'schedule'=>$q->fetchAll()]]);
    }

    // Student receipt upload: validate ownership, file size, MIME type, and pending duplicates.
    if($action==='payment_submit'){
        require_auth(['Student']);if($method!=='POST')respond(['success'=>false,'error'=>'Method not allowed.'],405);csrf_check();
        // This endpoint accepts multipart/form-data because the student attaches a receipt.
        $assessment=(int)($_POST['assessment_id']??0);$amount=round((float)($_POST['amount']??0),2);$reference=trim((string)($_POST['payment_reference']??''));$methodName=trim((string)($_POST['payment_method']??'Over-the-counter'));
        $q=$pdo->prepare('SELECT ass.id,ass.amount,ass.amount_paid,sp.id student_profile_id FROM assessments ass JOIN student_profiles sp ON sp.id=ass.student_profile_id WHERE ass.id=? AND sp.user_id=?');$q->execute([$assessment,$u['id']]);$ass=$q->fetch();
        if(!$ass)respond(['success'=>false,'error'=>'Assessment not found.'],404);$balance=(float)$ass['amount']-(float)$ass['amount_paid'];
        if($amount<=0||$amount>$balance||$reference===''||strlen($reference)>100)respond(['success'=>false,'error'=>'Enter a valid amount and payment reference. Amount cannot exceed the balance.'],422);
        $q=$pdo->prepare("SELECT COUNT(*) FROM payment_requests WHERE assessment_id=? AND status='pending'");$q->execute([$assessment]);if((int)$q->fetchColumn()>0)respond(['success'=>false,'error'=>'A pending payment already exists for this assessment.'],409);
        if(!isset($_FILES['receipt'])||$_FILES['receipt']['error']===UPLOAD_ERR_NO_FILE)respond(['success'=>false,'error'=>'Attach a payment receipt (PDF or JPEG).'],422);
        $file=$_FILES['receipt'];$limit=(int)($config['max_upload_bytes']??5242880);
        if($file['error']!==UPLOAD_ERR_OK||$file['size']<1||$file['size']>$limit)respond(['success'=>false,'error'=>'The receipt could not be uploaded or exceeds the 5 MB limit.'],422);
        $mime=(new finfo(FILEINFO_MIME_TYPE))->file($file['tmp_name']);if(!in_array($mime,['application/pdf','image/jpeg'],true))respond(['success'=>false,'error'=>'Only PDF and JPEG receipts are accepted.'],422);
        $extension=$mime==='application/pdf'?'pdf':'jpg';$stored='payment_'.bin2hex(random_bytes(16)).'.'.$extension;$directory=dirname(__DIR__,2).'/storage/private_uploads';if(!is_dir($directory)&&!mkdir($directory,0750,true))throw new RuntimeException('Receipt storage is unavailable.');
        $path=$directory.'/'.$stored;if(!move_uploaded_file($file['tmp_name'],$path))throw new RuntimeException('Receipt storage failed.');
        try{$q=$pdo->prepare("INSERT INTO payment_requests(assessment_id,student_profile_id,amount,payment_method,payment_reference,receipt_stored_name,receipt_original_name,receipt_mime_type,receipt_file_size,status) VALUES(?,?,?,?,?,?,?,?,?,'pending')");$q->execute([$assessment,$ass['student_profile_id'],$amount,$methodName,$reference,$stored,basename((string)$file['name']),$mime,(int)$file['size']]);}catch(Throwable $error){if(is_file($path))@unlink($path);throw $error;}
        $id=(int)$pdo->lastInsertId();audit('payment.submit','payment_requests',$id);respond(['success'=>true,'data'=>['id'=>$id,'status'=>'pending']]);
    }

    if($action==='payment_list'){
        require_permission('finance.manage');$rows=$pdo->query("SELECT pr.id,pr.assessment_id,pr.amount,pr.payment_method,pr.payment_reference,pr.receipt_original_name,pr.receipt_file_size,pr.status,pr.processor_notes,pr.created_at,pr.processed_at,sp.student_number,CONCAT(a.last_name,', ',a.first_name) student_name,ass.description FROM payment_requests pr JOIN student_profiles sp ON sp.id=pr.student_profile_id JOIN applications a ON a.id=sp.application_id JOIN assessments ass ON ass.id=pr.assessment_id ORDER BY FIELD(pr.status,'pending','approved','rejected'),pr.created_at DESC")->fetchAll();respond(['success'=>true,'data'=>$rows]);
    }

    if($action==='payment_receipt'){
        require_permission('finance.manage');$id=(int)($_GET['id']??0);$q=$pdo->prepare('SELECT receipt_stored_name,receipt_original_name,receipt_mime_type FROM payment_requests WHERE id=?');$q->execute([$id]);$receipt=$q->fetch();if(!$receipt||!$receipt['receipt_stored_name'])respond(['success'=>false,'error'=>'Receipt not found.'],404);
        $path=dirname(__DIR__,2).'/storage/private_uploads/'.basename((string)$receipt['receipt_stored_name']);if(!is_file($path))respond(['success'=>false,'error'=>'The receipt file is unavailable.'],404);
        header('Content-Type: '.$receipt['receipt_mime_type']);header('Content-Length: '.filesize($path));header("Content-Disposition: inline; filename*=UTF-8''".rawurlencode((string)$receipt['receipt_original_name']));header('X-Content-Type-Options: nosniff');header('Cache-Control: private, no-store');readfile($path);exit;
    }

    // Approval adds the verified amount to the assessment; rejection leaves the balance unchanged.
    if($action==='payment_process'){
        $operator=require_permission('finance.manage');if($method!=='POST')respond(['success'=>false,'error'=>'Method not allowed.'],405);csrf_check();$id=(int)($data['id']??0);$status=(string)($data['status']??'');$notes=trim((string)($data['notes']??''));if(!in_array($status,['approved','rejected'],true))respond(['success'=>false,'error'=>'Invalid payment decision.'],422);
        $pdo->beginTransaction();$q=$pdo->prepare('SELECT * FROM payment_requests WHERE id=? FOR UPDATE');$q->execute([$id]);$payment=$q->fetch();if(!$payment||$payment['status']!=='pending'){$pdo->rollBack();respond(['success'=>false,'error'=>'Payment request is unavailable or already processed.'],409);}
        if($status==='approved'){$q=$pdo->prepare('UPDATE assessments SET amount_paid=LEAST(amount,amount_paid+?) WHERE id=?');$q->execute([$payment['amount'],$payment['assessment_id']]);}
        $q=$pdo->prepare('UPDATE payment_requests SET status=?,processor_notes=?,processed_by=?,processed_at=NOW() WHERE id=?');$q->execute([$status,$notes?:null,$operator['id'],$id]);$pdo->commit();audit('payment.'.$status,'payment_requests',$id);respond(['success'=>true,'data'=>['status'=>$status]]);
    }
}
