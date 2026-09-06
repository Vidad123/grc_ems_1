<?php
declare(strict_types=1);

function management_permission(string $module): string {
    switch($module){
        case 'students': return 'students.manage';
        case 'users': return 'users.manage';
        case 'assessments': return 'finance.manage';
        case 'programs': case 'sections': case 'subjects': case 'schedules': return 'academics.manage';
        case 'announcements': return 'announcements.manage';
        default: return '';
    }
}

function management_text(array $data,string $key,int $max=190): string {
    $value=trim((string)($data[$key]??''));
    if($value===''||strlen($value)>$max)respond(['success'=>false,'error'=>ucwords(str_replace('_',' ',$key))." is required and must not exceed $max characters."],422);
    return $value;
}

function management_options(PDO $pdo): array {
    return [
        'programs'=>$pdo->query('SELECT id,program_code,program_name FROM programs ORDER BY program_code')->fetchAll(),
        'sections'=>$pdo->query('SELECT id,section_name,program_id FROM sections ORDER BY section_name')->fetchAll(),
        'students'=>$pdo->query("SELECT sp.id,sp.student_number,CONCAT(a.last_name,', ',a.first_name) name FROM student_profiles sp JOIN applications a ON a.id=sp.application_id WHERE sp.is_active=1 ORDER BY a.last_name,a.first_name")->fetchAll(),
        'subjects'=>$pdo->query('SELECT id,subject_code,subject_name FROM subjects ORDER BY subject_code')->fetchAll(),
        'roles'=>$pdo->query("SELECT id,role_name FROM roles WHERE role_name IN ('Admin','Staff','Teacher','Registrar') ORDER BY FIELD(role_name,'Admin','Registrar','Staff','Teacher')")->fetchAll(),
    ];
}

function management_rows(PDO $pdo,string $module): array {
    switch($module){
        case 'students': return $pdo->query("SELECT sp.id,sp.student_number,sp.program_id,sp.section_id,sp.is_active,a.first_name,a.middle_name,a.last_name,a.email,a.birth_date,a.contact_number,a.present_address,p.program_code,p.program_name,se.section_name,se.year_level,se.school_year,se.semester FROM student_profiles sp JOIN applications a ON a.id=sp.application_id JOIN programs p ON p.id=sp.program_id LEFT JOIN sections se ON se.id=sp.section_id ORDER BY a.last_name,a.first_name")->fetchAll();
        case 'assessments': return $pdo->query("SELECT ass.id,ass.student_profile_id,ass.description,ass.amount,ass.amount_paid,ass.due_date,ass.school_year,ass.semester,sp.student_number,CONCAT(a.last_name,', ',a.first_name) student_name,CASE WHEN ass.amount_paid>=ass.amount THEN 'Paid' WHEN ass.amount_paid>0 THEN 'Partial' ELSE 'Unpaid' END payment_status FROM assessments ass JOIN student_profiles sp ON sp.id=ass.student_profile_id JOIN applications a ON a.id=sp.application_id ORDER BY ass.created_at DESC")->fetchAll();
        case 'programs': return $pdo->query('SELECT id,program_code,program_name,department,description,is_active FROM programs ORDER BY program_code')->fetchAll();
        case 'sections': return $pdo->query('SELECT se.id,se.section_name,se.program_id,se.year_level,se.school_year,se.semester,se.capacity,p.program_code,p.program_name,(SELECT COUNT(*) FROM student_profiles sp WHERE sp.section_id=se.id AND sp.is_active=1) student_count FROM sections se JOIN programs p ON p.id=se.program_id ORDER BY se.section_name')->fetchAll();
        case 'subjects': return $pdo->query('SELECT su.id,su.subject_code,su.subject_name,su.units,su.program_id,su.year_level,su.semester,p.program_code,p.program_name FROM subjects su LEFT JOIN programs p ON p.id=su.program_id ORDER BY su.subject_code')->fetchAll();
        case 'schedules': return $pdo->query("SELECT sc.id,sc.section_id,sc.subject_id,sc.day_of_week,TIME_FORMAT(sc.start_time,'%H:%i') start_time,TIME_FORMAT(sc.end_time,'%H:%i') end_time,sc.room,sc.instructor,se.section_name,su.subject_code,su.subject_name FROM class_schedules sc JOIN sections se ON se.id=sc.section_id JOIN subjects su ON su.id=sc.subject_id ORDER BY FIELD(sc.day_of_week,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'),sc.start_time")->fetchAll();
        case 'announcements': return $pdo->query('SELECT id,title,body,audience,is_published,published_at FROM announcements ORDER BY created_at DESC')->fetchAll();
        case 'users': return $pdo->query("SELECT u.id,u.username,u.email,u.role_id,u.status,u.must_change_password,u.created_at,r.role_name FROM users u JOIN roles r ON r.id=u.role_id WHERE r.role_name IN ('Admin','Staff','Teacher','Registrar') ORDER BY r.role_name,u.email")->fetchAll();
        default: return [];
    }
}

function handle_management_request(string $action,string $method,array $data): void {
    if(!in_array($action,['manage_list','manage_save','manage_delete','manage_detail'],true))return;
    $module=(string)($_GET['module']??$data['module']??'');$permission=management_permission($module);
    if($permission==='')respond(['success'=>false,'error'=>'Unknown management module.'],404);
    $operator=require_permission($permission);$pdo=db();
    if($action==='manage_list'){
        if($method!=='GET')respond(['success'=>false,'error'=>'Method not allowed.'],405);
        respond(['success'=>true,'data'=>['rows'=>management_rows($pdo,$module),'options'=>management_options($pdo)]]);
    }
    if($action==='manage_detail'){
        if($method!=='GET')respond(['success'=>false,'error'=>'Method not allowed.'],405);
        $id=(int)($_GET['id']??0);
        if($id<1)respond(['success'=>false,'error'=>'Select a record.'],422);
        if($module==='students'){
            $q=$pdo->prepare("SELECT sp.id,sp.student_number,sp.is_active,a.first_name,a.middle_name,a.last_name,a.email,a.birth_date,a.contact_number,a.present_address,p.program_code,p.program_name,se.section_name,se.year_level,se.school_year,se.semester FROM student_profiles sp JOIN applications a ON a.id=sp.application_id JOIN programs p ON p.id=sp.program_id LEFT JOIN sections se ON se.id=sp.section_id WHERE sp.id=?");$q->execute([$id]);$record=$q->fetch();
            if(!$record)respond(['success'=>false,'error'=>'Student record not found.'],404);
            $q=$pdo->prepare("SELECT su.subject_code,su.subject_name,su.units,sc.day_of_week,TIME_FORMAT(sc.start_time,'%h:%i %p') start_time,TIME_FORMAT(sc.end_time,'%h:%i %p') end_time,sc.room,sc.instructor FROM class_schedules sc JOIN subjects su ON su.id=sc.subject_id JOIN student_profiles sp ON sp.section_id=sc.section_id WHERE sp.id=? ORDER BY FIELD(sc.day_of_week,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'),sc.start_time");$q->execute([$id]);respond(['success'=>true,'data'=>['record'=>$record,'schedule'=>$q->fetchAll()]]);
        }
        if($module==='sections'){
            $q=$pdo->prepare('SELECT se.*,p.program_code,p.program_name FROM sections se JOIN programs p ON p.id=se.program_id WHERE se.id=?');$q->execute([$id]);$record=$q->fetch();if(!$record)respond(['success'=>false,'error'=>'Section not found.'],404);
            $q=$pdo->prepare("SELECT sp.student_number,CONCAT(a.last_name,', ',a.first_name) student_name,a.email FROM student_profiles sp JOIN applications a ON a.id=sp.application_id WHERE sp.section_id=? AND sp.is_active=1 ORDER BY a.last_name,a.first_name");$q->execute([$id]);$students=$q->fetchAll();
            $q=$pdo->prepare("SELECT su.subject_code,su.subject_name,su.units,sc.day_of_week,TIME_FORMAT(sc.start_time,'%h:%i %p') start_time,TIME_FORMAT(sc.end_time,'%h:%i %p') end_time,sc.room,sc.instructor FROM class_schedules sc JOIN subjects su ON su.id=sc.subject_id WHERE sc.section_id=? ORDER BY FIELD(sc.day_of_week,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'),sc.start_time");$q->execute([$id]);respond(['success'=>true,'data'=>['record'=>$record,'students'=>$students,'schedule'=>$q->fetchAll()]]);
        }
        if($module==='subjects'){
            $q=$pdo->prepare('SELECT su.*,p.program_code,p.program_name FROM subjects su LEFT JOIN programs p ON p.id=su.program_id WHERE su.id=?');$q->execute([$id]);$record=$q->fetch();if(!$record)respond(['success'=>false,'error'=>'Subject not found.'],404);
            $q=$pdo->prepare("SELECT se.section_name,se.school_year,se.semester,sc.day_of_week,TIME_FORMAT(sc.start_time,'%h:%i %p') start_time,TIME_FORMAT(sc.end_time,'%h:%i %p') end_time,sc.room,sc.instructor FROM class_schedules sc JOIN sections se ON se.id=sc.section_id WHERE sc.subject_id=? ORDER BY se.section_name,sc.day_of_week,sc.start_time");$q->execute([$id]);respond(['success'=>true,'data'=>['record'=>$record,'schedules'=>$q->fetchAll()]]);
        }
        respond(['success'=>false,'error'=>'Details are unavailable for this module.'],404);
    }
    if($method!=='POST')respond(['success'=>false,'error'=>'Method not allowed.'],405);
    csrf_check();$id=(int)($data['id']??0);
    if($action==='manage_save'){
        if($module==='users'){
            $username=management_text($data,'username',80);$email=strtolower(trim((string)($data['email']??'')));$role=(int)($data['role_id']??0);$status=(string)($data['status']??'active');
            if(!filter_var($email,FILTER_VALIDATE_EMAIL))respond(['success'=>false,'error'=>'Enter a valid account email.'],422);
            if(!in_array($status,['active','inactive','locked'],true))$status='active';
            $q=$pdo->prepare("SELECT id,role_name FROM roles WHERE id=? AND role_name IN ('Admin','Staff','Teacher','Registrar')");$q->execute([$role]);if(!$q->fetch())respond(['success'=>false,'error'=>'Select a valid staff account role.'],422);
            $password=(string)($data['password']??'');
            if($id){$params=[$username,$email,$role,$status,!empty($data['must_change_password'])?1:0];$sql='UPDATE users SET username=?,email=?,role_id=?,status=?,must_change_password=?';if($password!==''){if(strlen($password)<8)respond(['success'=>false,'error'=>'Password must contain at least 8 characters.'],422);$sql.=',password_hash=?';$params[]=password_hash($password,PASSWORD_DEFAULT);}$params[]=$id;$pdo->prepare($sql.' WHERE id=?')->execute($params);
            }else{if(strlen($password)<8)respond(['success'=>false,'error'=>'Enter a temporary password with at least 8 characters.'],422);$pdo->prepare('INSERT INTO users(username,email,password_hash,role_id,status,must_change_password,email_verified_at) VALUES(?,?,?,?,?,?,NOW())')->execute([$username,$email,password_hash($password,PASSWORD_DEFAULT),$role,$status,!empty($data['must_change_password'])?1:0]);$id=(int)$pdo->lastInsertId();}
        }elseif($module==='students'){
            $first=management_text($data,'first_name',100);$last=management_text($data,'last_name',100);$email=strtolower(trim((string)($data['email']??'')));
            if(!filter_var($email,FILTER_VALIDATE_EMAIL))respond(['success'=>false,'error'=>'Enter a valid student email address.'],422);
            $program=(int)($data['program_id']??0);$section=($data['section_id']??'')!==''?(int)$data['section_id']:null;if($program<1)respond(['success'=>false,'error'=>'Select a program.'],422);
            if($section){$q=$pdo->prepare('SELECT program_id FROM sections WHERE id=?');$q->execute([$section]);$sectionProgram=$q->fetchColumn();if(!$sectionProgram)respond(['success'=>false,'error'=>'The selected section does not exist.'],422);if((int)$sectionProgram!==$program)respond(['success'=>false,'error'=>'The selected section does not belong to the student\'s program.'],422);}
            if($id){
                $q=$pdo->prepare('SELECT user_id,application_id FROM student_profiles WHERE id=?');$q->execute([$id]);$record=$q->fetch();if(!$record)respond(['success'=>false,'error'=>'Student record not found.'],404);
                $pdo->beginTransaction();
                $pdo->prepare('UPDATE applications SET first_name=?,middle_name=?,last_name=?,email=?,birth_date=?,contact_number=?,present_address=?,program_id=? WHERE id=?')->execute([$first,trim((string)($data['middle_name']??''))?:null,$last,$email,($data['birth_date']??'')?:null,trim((string)($data['contact_number']??''))?:null,trim((string)($data['present_address']??''))?:null,$program,$record['application_id']]);
                $pdo->prepare('UPDATE users SET email=? WHERE id=?')->execute([$email,$record['user_id']]);
                $pdo->prepare('UPDATE student_profiles SET student_number=?,program_id=?,section_id=?,is_active=? WHERE id=?')->execute([management_text($data,'student_number',40),$program,$section,!empty($data['is_active'])?1:0,$id]);$pdo->commit();
            }else{
                $password=(string)($data['password']??'');if(strlen($password)<8)$password=temp_password($last,(int)date('Y'));
                $role=(int)$pdo->query("SELECT id FROM roles WHERE role_name='Student'")->fetchColumn();$pdo->beginTransaction();
                $reference=reference_id();$pdo->prepare("INSERT INTO applications(reference_id,email,first_name,middle_name,last_name,birth_date,contact_number,present_address,enrollment_type,program_id,status,privacy_consent,review_notes,reviewed_by,submitted_at,reviewed_at) VALUES(?,?,?,?,?,?,?,?, 'new',?,'approved',1,'Manually encoded accepted student',?,NOW(),NOW())")->execute([$reference,$email,$first,trim((string)($data['middle_name']??''))?:null,$last,($data['birth_date']??'')?:null,trim((string)($data['contact_number']??''))?:null,trim((string)($data['present_address']??''))?:null,$program,$operator['id']]);$application=(int)$pdo->lastInsertId();
                $username='student'.date('y').bin2hex(random_bytes(3));$pdo->prepare("INSERT INTO users(username,email,password_hash,role_id,status,must_change_password,email_verified_at) VALUES(?,?,?,?,'active',1,NOW())")->execute([$username,$email,password_hash($password,PASSWORD_DEFAULT),$role]);$userId=(int)$pdo->lastInsertId();$studentNo=trim((string)($data['student_number']??''))?:'GRC-'.date('Y').'-'.str_pad((string)$userId,5,'0',STR_PAD_LEFT);
                $pdo->prepare('INSERT INTO student_profiles(user_id,application_id,student_number,program_id,section_id,is_active) VALUES(?,?,?,?,?,1)')->execute([$userId,$application,$studentNo,$program,$section]);$id=(int)$pdo->lastInsertId();$pdo->prepare("INSERT INTO assessments(student_profile_id,description,amount,amount_paid,due_date,school_year,semester) VALUES(?, 'Tuition fee',15000.00,0.00,DATE_ADD(CURDATE(),INTERVAL 30 DAY),'2026-2027','1st'),(?, 'Miscellaneous fees',3500.00,0.00,DATE_ADD(CURDATE(),INTERVAL 30 DAY),'2026-2027','1st')")->execute([$id,$id]);$pdo->commit();
                audit('student.manual_create','student_profiles',$id);respond(['success'=>true,'data'=>['id'=>$id,'temporary_password'=>$password]]);
            }
        }elseif($module==='assessments'){
            $student=(int)($data['student_profile_id']??0);$description=management_text($data,'description');$amount=(float)($data['amount']??-1);$paid=(float)($data['amount_paid']??0);
            if($student<1||$amount<0||$paid<0||$paid>$amount)respond(['success'=>false,'error'=>'Select a student and enter valid amounts. Amount paid cannot exceed the assessment.'],422);
            $values=[$student,$description,$amount,$paid,($data['due_date']??'')?:null,management_text($data,'school_year',20),management_text($data,'semester',20)];
            if($id){$values[]=$id;$pdo->prepare('UPDATE assessments SET student_profile_id=?,description=?,amount=?,amount_paid=?,due_date=?,school_year=?,semester=? WHERE id=?')->execute($values);}else{$pdo->prepare('INSERT INTO assessments(student_profile_id,description,amount,amount_paid,due_date,school_year,semester) VALUES(?,?,?,?,?,?,?)')->execute($values);$id=(int)$pdo->lastInsertId();}
        }elseif($module==='programs'){
            $values=[strtoupper(management_text($data,'program_code',30)),management_text($data,'program_name'),trim((string)($data['department']??''))?:null,trim((string)($data['description']??''))?:null,!empty($data['is_active'])?1:0];
            if($id){$values[]=$id;$pdo->prepare('UPDATE programs SET program_code=?,program_name=?,department=?,description=?,is_active=? WHERE id=?')->execute($values);}else{$pdo->prepare('INSERT INTO programs(program_code,program_name,department,description,is_active) VALUES(?,?,?,?,?)')->execute($values);$id=(int)$pdo->lastInsertId();}
        }elseif($module==='sections'){
            $values=[management_text($data,'section_name',80),(int)($data['program_id']??0),(int)($data['year_level']??0),management_text($data,'school_year',20),management_text($data,'semester',20),(int)($data['capacity']??40)];if($values[1]<1||$values[2]<1||$values[5]<1)respond(['success'=>false,'error'=>'Program, year level, and capacity are required.'],422);
            if($id){$values[]=$id;$pdo->prepare('UPDATE sections SET section_name=?,program_id=?,year_level=?,school_year=?,semester=?,capacity=? WHERE id=?')->execute($values);}else{$pdo->prepare('INSERT INTO sections(section_name,program_id,year_level,school_year,semester,capacity) VALUES(?,?,?,?,?,?)')->execute($values);$id=(int)$pdo->lastInsertId();}
        }elseif($module==='subjects'){
            $program=($data['program_id']??'')!==''?(int)$data['program_id']:null;$values=[strtoupper(management_text($data,'subject_code',30)),management_text($data,'subject_name'),(float)($data['units']??3),$program,(int)($data['year_level']??1),management_text($data,'semester',20)];
            if($id){$values[]=$id;$pdo->prepare('UPDATE subjects SET subject_code=?,subject_name=?,units=?,program_id=?,year_level=?,semester=? WHERE id=?')->execute($values);}else{$pdo->prepare('INSERT INTO subjects(subject_code,subject_name,units,program_id,year_level,semester) VALUES(?,?,?,?,?,?)')->execute($values);$id=(int)$pdo->lastInsertId();}
        }elseif($module==='schedules'){
            $day=(string)($data['day_of_week']??'');if(!in_array($day,['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'],true))respond(['success'=>false,'error'=>'Select a valid class day.'],422);$start=(string)($data['start_time']??'');$end=(string)($data['end_time']??'');if($start===''||$end===''||$start>=$end)respond(['success'=>false,'error'=>'End time must be later than start time.'],422);
            $values=[(int)($data['section_id']??0),(int)($data['subject_id']??0),$day,$start,$end,management_text($data,'room',80),management_text($data,'instructor')];if($values[0]<1||$values[1]<1)respond(['success'=>false,'error'=>'Select a section and subject.'],422);
            $q=$pdo->prepare('SELECT se.program_id section_program,su.program_id subject_program FROM sections se JOIN subjects su ON su.id=? WHERE se.id=?');$q->execute([$values[1],$values[0]]);$academic=$q->fetch();if(!$academic)respond(['success'=>false,'error'=>'The selected section or subject does not exist.'],422);if($academic['subject_program']!==null&&(int)$academic['subject_program']!==(int)$academic['section_program'])respond(['success'=>false,'error'=>'The selected subject does not belong to the section\'s program.'],422);
            $q=$pdo->prepare('SELECT COUNT(*) FROM class_schedules WHERE section_id=? AND day_of_week=? AND id<>? AND start_time<? AND end_time>?');$q->execute([$values[0],$day,$id,$end,$start]);if((int)$q->fetchColumn()>0)respond(['success'=>false,'error'=>'This section already has a class during the selected time.'],409);
            if($id){$values[]=$id;$pdo->prepare('UPDATE class_schedules SET section_id=?,subject_id=?,day_of_week=?,start_time=?,end_time=?,room=?,instructor=? WHERE id=?')->execute($values);}else{$pdo->prepare('INSERT INTO class_schedules(section_id,subject_id,day_of_week,start_time,end_time,room,instructor) VALUES(?,?,?,?,?,?,?)')->execute($values);$id=(int)$pdo->lastInsertId();}
        }elseif($module==='announcements'){
            $audience=(string)($data['audience']??'all');if(!in_array($audience,['all','students','staff'],true))$audience='all';$values=[management_text($data,'title'),management_text($data,'body',5000),$audience,!empty($data['is_published'])?1:0,$operator['id']];
            if($id){$values[]=$id;$pdo->prepare('UPDATE announcements SET title=?,body=?,audience=?,is_published=?,published_by=?,published_at=IF(?=1,NOW(),published_at) WHERE id=?')->execute([$values[0],$values[1],$values[2],$values[3],$values[4],$values[3],$id]);}else{$pdo->prepare('INSERT INTO announcements(title,body,audience,is_published,published_by,published_at) VALUES(?,?,?,?,?,IF(?=1,NOW(),NULL))')->execute([$values[0],$values[1],$values[2],$values[3],$values[4],$values[3]]);$id=(int)$pdo->lastInsertId();}
        }
        audit($module.'.save',$module,$id);respond(['success'=>true,'data'=>['id'=>$id]]);
    }
    if($action==='manage_delete'){
        if($id<1)respond(['success'=>false,'error'=>'Select a record to delete.'],422);
        if($module==='users'){
            if($id===(int)$operator['id'])respond(['success'=>false,'error'=>'You cannot delete your own account.'],409);
            $q=$pdo->prepare("SELECT r.role_name FROM users u JOIN roles r ON r.id=u.role_id WHERE u.id=?");$q->execute([$id]);$role=$q->fetchColumn();if(!in_array($role,['Admin','Staff','Teacher','Registrar'],true))respond(['success'=>false,'error'=>'Only staff accounts can be deleted here.'],409);$pdo->prepare('DELETE FROM users WHERE id=?')->execute([$id]);
        }elseif($module==='students'){
            $q=$pdo->prepare('SELECT sp.user_id,sp.application_id FROM student_profiles sp WHERE sp.id=?');$q->execute([$id]);$record=$q->fetch();if(!$record)respond(['success'=>false,'error'=>'Student record not found.'],404);
            $q=$pdo->prepare('SELECT stored_name FROM application_documents WHERE application_id=?');$q->execute([$record['application_id']]);$files=$q->fetchAll(PDO::FETCH_COLUMN);$pdo->beginTransaction();$pdo->prepare('DELETE tm FROM ticket_messages tm JOIN tickets t ON t.id=tm.ticket_id WHERE t.student_user_id=?')->execute([$record['user_id']]);$pdo->prepare('DELETE FROM tickets WHERE student_user_id=?')->execute([$record['user_id']]);$pdo->prepare('DELETE FROM users WHERE id=?')->execute([$record['user_id']]);$pdo->prepare('DELETE FROM applications WHERE id=?')->execute([$record['application_id']]);$pdo->commit();foreach($files as $file){$path=dirname(__DIR__,2).'/storage/private_uploads/'.basename((string)$file);if(is_file($path))@unlink($path);}
        }elseif($module==='assessments'){$pdo->prepare('DELETE FROM assessments WHERE id=?')->execute([$id]);
        }elseif($module==='programs'){foreach(['applications','student_profiles','sections','subjects'] as $table){$q=$pdo->prepare("SELECT COUNT(*) FROM $table WHERE program_id=?");$q->execute([$id]);if((int)$q->fetchColumn()>0)respond(['success'=>false,'error'=>'This program is still used by enrollment records. Deactivate it instead of deleting it.'],409);}$pdo->prepare('DELETE FROM programs WHERE id=?')->execute([$id]);
        }elseif($module==='sections'){$pdo->prepare('DELETE FROM sections WHERE id=?')->execute([$id]);
        }elseif($module==='subjects'){$pdo->beginTransaction();$pdo->prepare('DELETE FROM class_schedules WHERE subject_id=?')->execute([$id]);$pdo->prepare('DELETE FROM subjects WHERE id=?')->execute([$id]);$pdo->commit();
        }elseif($module==='schedules'){$pdo->prepare('DELETE FROM class_schedules WHERE id=?')->execute([$id]);
        }elseif($module==='announcements'){$pdo->prepare('DELETE FROM announcements WHERE id=?')->execute([$id]);}
        audit($module.'.delete',$module,$id);respond(['success'=>true,'data'=>['deleted'=>true]]);
    }
}
