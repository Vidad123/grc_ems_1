-- Non-destructive update for an existing GRC EMS database.
-- Skip this file when importing schema.sql into a fresh database.
USE grc_ems;

ALTER TABLE assessments
  ADD COLUMN IF NOT EXISTS amount_paid DECIMAL(12,2) NOT NULL DEFAULT 0.00 AFTER amount,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at;

INSERT IGNORE INTO role_permissions(role_id,permission_id)
SELECT r.id,p.id
FROM roles r
JOIN permissions p ON p.permission_key='students.manage'
WHERE r.role_name='Registrar';

UPDATE permissions
SET description='Manage programs, sections, subjects, and schedules'
WHERE permission_key='academics.manage';

UPDATE permissions
SET description='Manage tuition and fee assessments'
WHERE permission_key='finance.manage';

-- Account management and teacher role.
INSERT IGNORE INTO roles(role_name,description) VALUES('Teacher','Teaching staff access');
INSERT IGNORE INTO permissions(permission_key,description) VALUES('users.manage','Manage staff and administrator accounts');
INSERT IGNORE INTO role_permissions(role_id,permission_id)
SELECT r.id,p.id FROM roles r JOIN permissions p ON p.permission_key='users.manage'
WHERE r.role_name IN ('Admin','Super Admin');
INSERT IGNORE INTO role_permissions(role_id,permission_id)
SELECT r.id,p.id FROM roles r JOIN permissions p ON p.permission_key IN ('tickets.manage','tickets.view')
WHERE r.role_name='Teacher';
