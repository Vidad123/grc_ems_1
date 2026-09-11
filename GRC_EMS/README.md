# GRC Enrollment Management System

HTML/CSS/JavaScript frontend with a PHP 8.1+ API and MySQL/MariaDB backend for Global Reciprocal Colleges.

## Latest profile and account update

For an existing database, import `database/database_update_profiles_accounts.sql` through phpMyAdmin, then replace the project files. The admin portal includes Account Management for Admin, Registrar, Staff, and Teacher accounts. Student and admin profile views show the assigned section, complete student information, subjects, schedules, rooms, and teachers.

For this role/profile/payment update, existing installations must also import `database/database_update_role_profiles_payments.sql` once. It preserves existing records while adding user profiles, teacher-section assignments, payment requests, and Registrar payment-processing permission.

For the receipt-verification update, existing installations must import `database/database_update_payment_receipts.sql` once. Students attach a private PDF/JPEG receipt (maximum 5 MB), and Admin, Super Admin, Registrar, or Staff must approve it before the recorded paid balance changes.

For Bill Management, existing installations must also import `database/database_update_assessment_bills.sql` once. A bill applies to all registered active students by default; the program filter is optional. The system creates individual assessments and bills for matching students, so each student's balance and payment history remain separate.

## Installation

1. Extract this folder into your server directory, such as htdocs/GRC_EMS in XAMPP.
2. In phpMyAdmin, choose Import and select `database/schema.sql`.
3. Edit config.example.php with your database host, port, database, username, and password. It is set to the standard MySQL port `3306`. The included config.php loads these values.
   Set `base_url` to the public system URL (for example, `https://school.example/GRC_EMS`) so credential emails contain the correct login link.
4. SMTP credentials are read from `config.local.php`. Update that file whenever the Gmail app password changes.
5. Never upload, share, or commit `config.local.php`. It is blocked from direct web access by the included `.htaccess` file.
6. Start Apache and MySQL, then open `index.html` through your XAMPP URL.

## Implemented

- Secure sessions and CSRF checks
- PHP password hashing and prepared SQL statements
- Super Admin, Admin, Registrar, Staff, Teacher, and Student authorization
- Multi-step student enrollment form
- Programs loaded from MySQL
- Student status portal
- Database-backed registrar metrics and application table
- Search, review, approve, reject, and under-review actions
- Audit logs for authentication and enrollment decisions
- Responsive UI and safe HTML output handling
- Public school homepage and admissions content
- Dedicated application.html page, separate from the school homepage
- GRC-aligned crimson, maroon, rose, and white institutional theme
- Streamlined application flow without draft/resume controls
- Private PDF/JPEG uploads with MIME and 5MB validation
- Action Required corrections with automated email notices
- Automatic student account and temporary-password generation on approval
- Automatic approval and rejection email templates with applicant-specific context
- Temporary student password format: `#` + first two surname letters + registration year (example: `#De2026`)
- Approval email includes the student number, login email, temporary password, and portal URL
- Rejection email includes review details and GRC contact/visit instructions
- The review message box is saved and included in correction, approval, and rejection emails
- Duplicate student emails are detected before approval and return a clear message
- Decision buttons are locked while processing to prevent duplicate accounts and emails
- Application submissions use an idempotency token and a locked submit button to prevent duplicates
- Existing active applications for the same email return the original reference number
- Submission no longer waits for SMTP; decision emails remain automated
- Mandatory password replacement on first student login
- Functional first-login password form with visible validation, loading, and success/error states
- Separate admin/, registrar/, staff/, and student/ role portals
- A dedicated static HTML page for every authorized role module
- HTML/CSS/JavaScript frontend with PHP retained only for API, database, session, RBAC, upload, and SMTP services
- Static module pages validate the current session and role before loading data; every API request also enforces server-side RBAC
- Student sections, subjects, schedules, balances, and announcements
- Helpdesk tickets with threaded replies and tracked status
- Functional Helpdesk queues with student-only ticket ownership, required-field validation, search, status filters, staff assignment, threaded replies, and Open/In Progress/Resolved/Closed controls
- Email-delivery history in email_logs
- Complete Create, Read, Edit/Update, and Delete actions for student profiles, assessments, programs, sections, subjects, schedules, and announcements
- Separate module pages for Student Profiling, Assessment & Billing, Programs, Sections, Subjects, and Class Scheduling
- Student profiling stores accepted-student personal details, contact information, program, section, and active standing
- Assessment & Billing calculates total assessment, administratively recorded paid amounts, and outstanding balances
- Students can submit payment references and receipt files from Assessment & Billing; Admin, Super Admin, Registrar, and Staff verify or reject each request before the balance changes
- Receipt verification is integrated directly below the records on the Assessment & Billing page; there is no separate Payment Processing navigation item
- Bill Management is a dedicated Assessment & Billing tab with create, read, edit, delete, search, and active/inactive filtering for detailed fee items; bills apply to all registered students or, optionally, one program
- This school-project workflow records payment verification only; it does not transfer money or connect to a real payment gateway
- Class scheduling connects sections, subjects, teachers, rooms, class days, and start/end times
- Server-side validation, prepared queries, confirmation dialogs, audit logging, and RBAC on all management actions
- Focused search and filters on Student Profiles and Sections
- Instant search on Assessment & Billing records
- Consistent SVG sidebar icons that work without external libraries
- Settings & Profile management for Admin, Registrar, Staff, Teacher, and Student
- Student profile settings reuse personal information originally submitted in the application form
- Teachers see only assigned sections, including enrolled students, subjects, rooms, and schedules
- Schedule teacher choices come only from active registered Teacher accounts; saving a schedule also assigns that teacher to the selected section

For an existing database, import `database/database_update_registered_schedule_teachers.sql` once before using the updated Schedule form.

## Project organization

See `docs/FOLDER_STRUCTURE.md` for the responsibility of each folder. Styles are kept in `assets/css`, browser scripts in `assets/js`, database files in `database`, and backend controllers/services under `api`.

## Email delivery

Email is configured for authenticated Gmail SMTP through `smtp.gmail.com` on port 587 with STARTTLS. It does not depend on XAMPP `sendmail.ini`. Approval creates the student account and sends credentials; rejection and correction decisions send contextual notices. The admin review screen reports whether delivery succeeded, and attempts are stored in `email_logs` for troubleshooting. Credential email logs are redacted so temporary passwords are not stored in plaintext.

The server must have PHP OpenSSL enabled and outbound access to `smtp.gmail.com:587`. For Gmail, two-step verification and an active app password are required.

## API routes

- GET api.php?action=csrf
- GET api.php?action=session
- GET api.php?action=programs
- POST api.php?action=application_save
- GET api.php?action=application_resume&reference=...&email=...
- POST api.php?action=login
- POST api.php?action=password_change
- GET api.php?action=portal&view=...
- POST api.php?action=application_review
- POST api.php?action=ticket_create
- GET api.php?action=ticket&id=...
- POST api.php?action=ticket_reply
- POST api.php?action=announcement_create
- GET api.php?action=manage_list&module=students|assessments|programs|sections|subjects|schedules|announcements
- POST api.php?action=manage_save&module=...
- POST api.php?action=manage_delete&module=...
- GET api.php?action=bill_list
- POST api.php?action=bill_save
- POST api.php?action=bill_bulk_create
- POST api.php?action=bill_delete

## Production checklist

- Replace the default administrator password.
- Use a dedicated least-privilege database account.
- Require HTTPS.
- Add SMTP verification and endpoint rate limiting.
- Store future document uploads outside the public web root.
- Disable PHP error display and retain server-side logging.
