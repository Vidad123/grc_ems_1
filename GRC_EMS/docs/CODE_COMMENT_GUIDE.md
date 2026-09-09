# GRC EMS Code Comment Guide

The system contains comments in the main source files so you can explain it during a project presentation:

- `api.php`: receives API requests, validates sessions/RBAC/CSRF, and returns JSON.
- `config.php`: database connection, secure session, permissions, audit log, and email helpers.
- `api/controllers/management.php`: CRUD validation for students, assessments, academics, schedules, announcements, and accounts.
- `api/controllers/user_features.php`: profiles, teacher sections, payment receipts, and payment verification.
- `assets/js/portal-shell.js`: role sidebar navigation and SVG icons.
- `assets/js/portal.js`: portal page rendering, application review, student billing, payments, and Helpdesk.
- `assets/js/management.js`: management forms, table rendering, search, filters, and Assessment & Billing tabs.

The comments explain each workflow or responsibility. Compact SQL statements are not commented line by line so the files remain readable.
