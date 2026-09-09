USE grc_ems;

-- Run this once in phpMyAdmin for an existing GRC EMS database.
ALTER TABLE payment_requests
  ADD COLUMN receipt_stored_name VARCHAR(255) NULL AFTER payment_reference,
  ADD COLUMN receipt_original_name VARCHAR(255) NULL AFTER receipt_stored_name,
  ADD COLUMN receipt_mime_type VARCHAR(100) NULL AFTER receipt_original_name,
  ADD COLUMN receipt_file_size INT UNSIGNED NULL AFTER receipt_mime_type;

-- Staff may review receipts and approve or reject submitted payment records.
INSERT IGNORE INTO role_permissions(role_id,permission_id)
SELECT r.id,p.id FROM roles r CROSS JOIN permissions p
WHERE r.role_name='Staff' AND p.permission_key='finance.manage';
