<?php
declare(strict_types=1);
require_once dirname(__DIR__,2).'/config.php';
final class MailService {
    public static function send(string $recipient,string $subject,string $html): bool {
        return send_system_mail($recipient,$subject,$html);
    }
}
