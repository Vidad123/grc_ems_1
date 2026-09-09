-- Run this once in phpMyAdmin for an existing GRC_EMS database.
-- Skip it if you imported the updated schema.sql into a new database.
USE grc_ems;
ALTER TABLE applications
  ADD COLUMN submission_token CHAR(64) NULL AFTER reference_id,
  ADD UNIQUE KEY uq_app_submission_token (submission_token);
