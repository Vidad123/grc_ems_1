-- GRC EMS: Assessment Bill Management migration
-- Import this file once in phpMyAdmin after selecting the grc_ems database.
USE grc_ems;

CREATE TABLE IF NOT EXISTS assessment_bills (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  assessment_id BIGINT UNSIGNED NOT NULL,
  bill_code VARCHAR(40) NOT NULL,
  bill_name VARCHAR(190) NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  due_date DATE NULL,
  notes TEXT NULL,
  is_active BOOLEAN NOT NULL DEFAULT 1,
  created_by BIGINT UNSIGNED NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_assessment_bills_assessment FOREIGN KEY (assessment_id) REFERENCES assessments(id) ON DELETE CASCADE,
  CONSTRAINT fk_assessment_bills_creator FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
  UNIQUE KEY uq_assessment_bill_code (assessment_id,bill_code),
  KEY idx_bill_assessment (assessment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
