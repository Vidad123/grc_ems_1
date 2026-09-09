USE grc_ems;

-- Run once in phpMyAdmin. Schedule forms will then accept only active Teacher accounts.
ALTER TABLE class_schedules
  ADD COLUMN teacher_user_id BIGINT UNSIGNED NULL AFTER subject_id,
  ADD INDEX idx_schedule_teacher (teacher_user_id),
  ADD CONSTRAINT fk_schedule_teacher FOREIGN KEY (teacher_user_id)
    REFERENCES users(id) ON DELETE SET NULL;

-- Link legacy schedules when their saved instructor text matches a Teacher username.
UPDATE class_schedules sc
JOIN users u ON LOWER(u.username)=LOWER(sc.instructor)
JOIN roles r ON r.id=u.role_id AND r.role_name='Teacher'
SET sc.teacher_user_id=u.id
WHERE sc.teacher_user_id IS NULL;

-- Existing unmatched names remain unassigned and are excluded from schedule lists.
