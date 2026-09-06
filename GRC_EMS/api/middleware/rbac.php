<?php
declare(strict_types=1);
// Shared RBAC entry point for future standalone API controllers.
// It delegates to config.php so every protected route uses the same permission rules.
require_once dirname(__DIR__,2).'/config.php';
function authorize_api(string $permission): array { return require_permission($permission); }
