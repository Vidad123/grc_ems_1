<?php
declare(strict_types=1);

// Load safe defaults, then allow config.local.php to override local credentials.
// Keep config.local.php private because it may contain database and SMTP secrets.
$config = require __DIR__ . '/config.example.php';
$localConfig=__DIR__.'/config.local.php';
if(is_file($localConfig))$config=array_replace($config,require $localConfig);

// Reuse one PDO connection for this request. Prepared statements protect SQL values.
function db(): PDO {
    static $pdo;
    global $config;
    if (!$pdo) {
        $dsn = sprintf('mysql:host=%s;port=%d;dbname=%s;charset=utf8mb4', $config['db_host'], (int)($config['db_port'] ?? 3306), $config['db_name']);
        $pdo = new PDO($dsn, $config['db_user'], $config['db_pass'], [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]);
    }
    return $pdo;
}

// Start the secure PHP session and create the CSRF token used by POST requests.
function boot_session(): void {
    if (session_status() !== PHP_SESSION_ACTIVE) {
        session_set_cookie_params(['httponly'=>true,'secure'=>isset($_SERVER['HTTPS']),'samesite'=>'Strict','path'=>'/']);
        session_start();
    }
    if (!isset($_SESSION['csrf'])) $_SESSION['csrf'] = bin2hex(random_bytes(32));
}

// Reject state-changing requests that do not carry this browser session's CSRF token.
function csrf_check(): void {
    $token = $_SERVER['HTTP_X_CSRF_TOKEN'] ?? ($_POST['csrf'] ?? '');
    if (!hash_equals($_SESSION['csrf'] ?? '', $token)) respond(['success'=>false,'error'=>'Invalid security token. Refresh and retry.'], 419);
}
function user(): ?array { return $_SESSION['user'] ?? null; }
// Stop the request if there is no logged-in user or their role is not allowed.
function require_auth(array $roles=[]): array {
    $u = user();
    if (!$u) respond(['success'=>false,'error'=>'Authentication required.'], 401);
    if ($roles && !in_array($u['role_name'], $roles, true)) respond(['success'=>false,'error'=>'You do not have permission for this action.'], 403);
    return $u;
}
// Resolve a permission through roles -> role_permissions -> permissions.
function can(string $permission): bool {
    $u=user(); if(!$u)return false;
    if($u['role_name']==='Super Admin')return true;
    $stmt=db()->prepare('SELECT COUNT(*) FROM role_permissions rp JOIN permissions p ON p.id=rp.permission_id JOIN roles r ON r.id=rp.role_id WHERE r.role_name=? AND p.permission_key=?');
    $stmt->execute([$u['role_name'],$permission]);
    return (bool)$stmt->fetchColumn();
}
function require_permission(string $permission): array {
    $u=require_auth();
    if(!can($permission)) respond(['success'=>false,'error'=>'Permission denied.'],403);
    return $u;
}
// Generate an application tracking number, for example GRC-APP-26-A1B2C3.
function reference_id(): string { return 'GRC-APP-'.date('y').'-'.strtoupper(bin2hex(random_bytes(3))); }
// Generate the temporary password included in the approval email, such as #De2026.
function temp_password(string $surname, ?int $year=null): string {
    $letters=preg_replace('/[^A-Za-z]/','',$surname)?:'Gr';
    $prefix=ucfirst(strtolower(substr($letters,0,2)));
    if(strlen($prefix)<2)$prefix=str_pad($prefix,2,'r');
    return '#'.$prefix.($year?:date('Y'));
}
// Build the URL placed in approval emails, even without a configured base URL.
function portal_login_url(): string {
    global $config;
    $base=rtrim((string)($config['base_url']??''),'/');
    if($base!=='')return $base.'/login.html';
    $scheme=(!empty($_SERVER['HTTPS'])&&$_SERVER['HTTPS']!=='off')?'https':'http';
    $host=$_SERVER['HTTP_HOST']??'localhost';
    $dir=rtrim(str_replace('\\','/',dirname($_SERVER['SCRIPT_NAME']??'/')),'/');
    return $scheme.'://'.$host.($dir?:'').'/login.html';
}
// Send through SMTP (or PHP mail) and record the result in email_logs.
function send_system_mail(string $to,string $subject,string $html,?string $loggedHtml=null): bool {
    global $config;
    $error=null;
    if(($config['mail_driver']??'smtp')==='smtp'){
        require_once __DIR__.'/api/services/SmtpClient.php';$mailer=new SmtpClient();$ok=$mailer->send($config,$to,$subject,$html);$error=$ok?null:$mailer->error();
    } else {
        $headers=['MIME-Version: 1.0','Content-type: text/html; charset=UTF-8','From: '.$config['mail_from_name'].' <'.$config['mail_from'].'>'];$ok=@mail($to,$subject,$html,implode("\r\n",$headers));$error=$ok?null:'Server mail transport rejected the message';
    }
    $stmt=db()->prepare('INSERT INTO email_logs(recipient,subject,body,status,error_message) VALUES(?,?,?,?,?)');
    $stmt->execute([$to,$subject,$loggedHtml??$html,$ok?'sent':'failed',$error]);
    return $ok;
}
// Send the standard JSON API response, then end execution.
function respond(array $payload, int $status=200) {
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($payload, JSON_UNESCAPED_SLASHES);
    exit;
}
// Keep an internal record of important actions for accountability.
function audit(string $action, ?string $table=null, ?int $target=null, array $details=[]): void {
    $stmt=db()->prepare('INSERT INTO audit_logs(user_id,action,target_table,target_id,ip_address,user_agent,details_json) VALUES(?,?,?,?,?,?,?)');
    $stmt->execute([user()['id']??null,$action,$table,$target,$_SERVER['REMOTE_ADDR']??null,substr($_SERVER['HTTP_USER_AGENT']??'',0,255),json_encode($details)]);
}
boot_session();
