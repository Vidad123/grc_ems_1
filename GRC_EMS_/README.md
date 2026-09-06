# GRC Enrollment Management System

HTML/CSS/JavaScript frontend with a PHP 8.1+ API and MySQL/MariaDB backend for Global Reciprocal Colleges.

## Latest profile and account update

For an existing database, import `database/database_update_profiles_accounts.sql` through phpMyAdmin, then replace the project files. The admin portal includes Account Management for Admin, Registrar, Staff, and Teacher accounts. Student and admin profile views show the assigned section, complete student information, subjects, schedules, rooms, and teachers.

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
- Email-delivery history in email_logs
- Complete Create, Read, Edit/Update, and Delete actions for student profiles, assessments, programs, sections, subjects, schedules, and announcements
- Separate module pages for Student Profiling, Assessment & Billing, Programs, Sections, Subjects, and Class Scheduling
- Student profiling stores accepted-student personal details, contact information, program, section, and active standing
- Assessment & Billing calculates total assessment, administratively recorded paid amounts, and outstanding balances
- No online payment collection, payment gateway, card processing, or checkout functionality
- Class scheduling connects sections, subjects, teachers, rooms, class days, and start/end times
- Server-side validation, prepared queries, confirmation dialogs, audit logging, and RBAC on all management actions
- Focused search and filters on Student Profiles and Sections
- Instant search on Assessment & Billing records
- Consistent SVG sidebar icons that work without external libraries

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

## Production checklist

- Replace the default administrator password.
- Use a dedicated least-privilege database account.
- Require HTTPS.
- Add SMTP verification and endpoint rate limiting.
- Store future document uploads outside the public web root.
- Disable PHP error display and retain server-side logging.
