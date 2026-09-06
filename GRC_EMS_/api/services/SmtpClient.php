<?php
declare(strict_types=1);

final class SmtpClient {
    private $socket=null;
    private string $error='';

    public function error(): string { return $this->error; }

    public function send(array $settings,string $to,string $subject,string $html): bool {
        try {
            $host=(string)$settings['smtp_host'];$port=(int)$settings['smtp_port'];
            $timeout=(int)($settings['smtp_timeout']??20);
            $this->socket=@fsockopen($host,$port,$errno,$errstr,$timeout);
            if(!$this->socket)throw new RuntimeException("SMTP connection failed: $errstr ($errno)");
            stream_set_timeout($this->socket,$timeout);
            $this->expect([220]);
            $client=$_SERVER['SERVER_NAME']??'localhost';
            $this->command('EHLO '.$client,[250]);
            if(($settings['smtp_encryption']??'tls')==='tls'){
                $this->command('STARTTLS',[220]);
                if(!stream_socket_enable_crypto($this->socket,true,STREAM_CRYPTO_METHOD_TLS_CLIENT))throw new RuntimeException('Could not start TLS encryption.');
                $this->command('EHLO '.$client,[250]);
            }
            $username=trim((string)$settings['smtp_username']);
            $password=preg_replace('/\s+/u','',(string)$settings['smtp_password']);
            if($username===''||$password==='')throw new RuntimeException('SMTP username or app password is missing.');
            $this->command('AUTH LOGIN',[334]);$this->command(base64_encode($username),[334]);$this->command(base64_encode($password),[235]);
            $from=trim((string)$settings['mail_from']);
            if(!filter_var($from,FILTER_VALIDATE_EMAIL)||!filter_var($to,FILTER_VALIDATE_EMAIL))throw new RuntimeException('Invalid sender or recipient email address.');
            $this->command('MAIL FROM:<'.$from.'>',[250]);$this->command('RCPT TO:<'.$to.'>',[250,251]);$this->command('DATA',[354]);
            $fromName=(string)($settings['mail_from_name']??'GRC Admissions');
            $encodedName='=?UTF-8?B?'.base64_encode($fromName).'?=';$encodedSubject='=?UTF-8?B?'.base64_encode($subject).'?=';
            $headers=['Date: '.date(DATE_RFC2822),'From: '.$encodedName.' <'.$from.'>','To: <'.$to.'>','Subject: '.$encodedSubject,'MIME-Version: 1.0','Content-Type: text/html; charset=UTF-8','Content-Transfer-Encoding: 8bit','Message-ID: <'.bin2hex(random_bytes(12)).'@'.preg_replace('/[^A-Za-z0-9.-]/','',$client).'>'];
            $body=preg_replace('/^\./m','..',str_replace(["\r\n","\r"],"\n",$html));
            fwrite($this->socket,implode("\r\n",$headers)."\r\n\r\n".str_replace("\n","\r\n",$body)."\r\n.\r\n");
            $this->expect([250]);$this->command('QUIT',[221]);fclose($this->socket);$this->socket=null;return true;
        } catch(Throwable $e) {
            $this->error=$e->getMessage();
            if(is_resource($this->socket))fclose($this->socket);
            $this->socket=null;return false;
        }
    }

    private function command(string $command,array $codes): void { fwrite($this->socket,$command."\r\n");$this->expect($codes); }
    private function expect(array $codes): void {
        $response='';$code=0;
        while(($line=fgets($this->socket,515))!==false){$response.=$line;$code=(int)substr($line,0,3);if(strlen($line)>3&&$line[3]===' ')break;}
        if(!in_array($code,$codes,true))throw new RuntimeException('SMTP server error: '.trim($response));
    }
}
