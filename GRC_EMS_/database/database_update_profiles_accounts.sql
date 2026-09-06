-- Import this non-destructive update into your existing grc_ems database.
-- XAMPP MySQL connection remains on port 3306.
USE grc_ems;

INSERT IGNORE INTO roles(role_name,description)
VALUES ('Teacher','Teaching staff access');

INSERT IGNORE INTO permissions(permission_key,description)
VALUES ('users.manage','Manage staff and administrator accounts');

INSERT IGNORE INTO role_permissions(role_id,permission_id)
SELECT r.id,p.id
FROM roles r JOIN permissions p ON p.permission_key='users.manage'
WHERE r.role_name IN ('Admin','Super Admin');

INSERT IGNORE INTO role_permissions(role_id,permission_id)
SELECT r.id,p.id
FROM roles r JOIN permissions p ON p.permission_key IN ('tickets.manage','tickets.view')
WHERE r.role_name='Teacher';
