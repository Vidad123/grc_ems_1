# API integration guide

All endpoints return JSON in this format:

    {"success": true, "data": {}}
    {"success": false, "error": "Message"}

Public endpoints:

- GET ../api.php?action=csrf
- GET ../api.php?action=programs
- POST ../api.php?action=application_save (multipart/form-data)
- GET ../api.php?action=application_resume&reference=...&email=...

Authenticated endpoints:

- POST ../api.php?action=login
- POST ../api.php?action=logout
- POST ../api.php?action=password_change
- GET ../api.php?action=portal&view=admin-dashboard
- GET ../api.php?action=portal&view=applications
- GET ../api.php?action=portal&view=students
- GET ../api.php?action=portal&view=academics
- GET ../api.php?action=portal&view=student-dashboard
- GET ../api.php?action=portal&view=schedule
- GET ../api.php?action=portal&view=finance
- GET ../api.php?action=manage_list&module=students
- POST ../api.php?action=manage_save&module=students
- POST ../api.php?action=manage_delete&module=students

The management routes also support `assessments`, `programs`, `sections`, `subjects`, `schedules`, and `announcements`. They require the corresponding RBAC permission and CSRF token. Assessment records are informational and administrative only; there is no online payment endpoint.
- GET ../api.php?action=portal&view=announcements
- GET ../api.php?action=portal&view=helpdesk
- POST ../api.php?action=application_review
- POST ../api.php?action=ticket_create
- GET ../api.php?action=ticket&id=...
- POST ../api.php?action=ticket_reply
- POST ../api.php?action=announcement_create

State-changing requests require the X-CSRF-Token header. Protected endpoints
enforce database-backed role permissions server-side.
