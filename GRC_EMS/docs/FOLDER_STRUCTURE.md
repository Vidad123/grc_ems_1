# GRC EMS folder structure

```text
GRC_EMS/
├── admin/                 Admin module pages
├── registrar/             Registrar module pages
├── staff/                 Staff module pages
├── student/               Student portal pages
├── teacher/               Teacher portal pages
├── api/
│   ├── controllers/       API business and CRUD controllers
│   ├── middleware/        Authorization helpers
│   └── services/          SMTP and other backend services
├── assets/
│   ├── css/               Shared and page-specific styles
│   ├── js/                Browser behavior and API clients
│   ├── logo_grc.png       Login logo
│   └── logo_grc_1.png     Portal and public-page logo
├── database/              Fresh schema and incremental updates
├── docs/                  Developer documentation
├── storage/               Protected uploaded documents
├── api.php                Public API entry point
├── config.php             Database, session, RBAC, and mail helpers
├── config.example.php     Safe default configuration
├── config.local.php       Local private SMTP override
├── index.html             School homepage
├── application.html       Enrollment application
└── login.html             Role portal login
```

## Conventions

- Keep each role module in its own page.
- Keep browser code out of HTML whenever behavior is shared.
- Send all backend requests through `api.php`.
- Put reusable server logic in `api/controllers` or `api/services`.
- Use prepared PDO statements for values supplied by users.
- Require RBAC permissions and CSRF validation for protected writes.
- Use `database/schema.sql` only for a fresh database.
- Use the files named `database_update_*.sql` for existing databases.
- Do not store uploaded documents in a publicly browsable directory.
- Do not change the two logo files when updating unrelated modules.
