# AGENTS.md

## Stack
- **Ruby 3.3.7**, **Rails 7.2**, **Node 18.0.0**, **PostgreSQL**
- PostgreSQL adapter, no Redis or background jobs configured

## Development commands

```bash
# Start all dev processes (web server + JS build + CSS watch)
bin/dev

# Or run individually:
bin/rails server           # web on :3000
yarn build --watch         # JS via esbuild
yarn watch:css             # Sass → CSS with autoprefixer

# Database
bin/rails db:migrate
bin/rails db:seed

# Lint & security
bin/rubocop                # Style lint (rubocop-rails-omakase)
bin/brakeman               # Security scan

# Console
bin/rails console
```

**No test suite exists** — there is no `test/` or `spec/` directory. CI only runs `bin/brakeman` and `bin/rubocop`.

## Architecture

### Key gems
| Gem | Purpose |
|-|-|
| `devise` | Authentication (all pages require login) |
| `cancancan` | Authorization via `app/models/ability.rb` |
| `aasm` | State machine for MonthlyReport status |
| `carrierwave` + `fog-aws` | File uploads (S3 in prod, local disk otherwise) |
| `wicked_pdf` + `wkhtmltopdf-binary` | PDF export of monthly reports |
| `simple_form` + `bootstrap` | Forms and UI |
| `letter_opener` | Dev email preview |
| `rails-i18n` | Spanish translations |

### Locale
Hard-coded to Spanish: `ApplicationController` sets `I18n.locale = "es"` for every request.

### User roles (enum on User model)
`admin` (0), `director` (1), `coordinator` (2), `professional` (3), `inspector` (4)

Permissions defined in `app/models/ability.rb`. The `ALLOWED_EVENTS_PER_ROLE` constant in `MonthlyReport` controls which AASM events each role can trigger.

### MonthlyReport workflow (AASM)
```
created → reported → approved ⇄ revised
```
State transitions are triggered via `MonthlyReports::TriggerEventService` (handles permission checks + AASM event dispatch). The allowed events per role are:
- admin: all events
- director/coordinator: `report`, `unreport`, `approve`, `unapprove`
- inspector: `revise`, `unrevise`
- professional: `report`, `unreport`

### CustomSelectList system
A generic mechanism for admin-defined dropdown options. Each `CustomSelectList` belongs to a model (stored as `model_name_association`), has many `CustomOptionList` (keyed by field name), each with many `CustomOption` (label strings). Models reference lists via `belongs_to :custom_select_list` and declare `OPTION_LISTABLE_FIELDS` to drive dynamic select rendering. **When adding a new model with select fields, a CustomSelectList record must exist for it.**

### File uploads
- CarrierWave uploader: `SourceFileUploader` (allows `pdf doc docx xls xlsx csv png jpg jpeg`)
- Storage: local disk in dev/test, AWS S3 (`sa-east-1`) in production via `fog-aws`
- Max file size: 3MB per file
- Uploaded via `mount_uploader` / `mount_uploaders` on `SocialEcologicalCharacterization#source_file`, `MonthlyReport#legal_documents`, `Activity#source_files`

### Frontend
- **esbuild** bundles JS from `app/javascript/` → `app/assets/builds/`
- **Sass** compiles `app/assets/stylesheets/application.bootstrap.scss` → `app/assets/builds/`
- **Bootstrap 5** with Bootstrap Icons
- **Stimulus** controllers in `app/javascript/controllers/` (flatpickr, remote modal, toast notifications, nested forms)
- **Turbo** for SPA-like navigation, many views use `.turbo_stream.erb` responses

### Production
- Dockerized (see `Dockerfile`), deployed via Kamal or manual
- Gmail SMTP for outgoing mail
- AWS S3 for uploads (credentials in Rails encrypted credentials)
- Assets precompiled during Docker build, `pdf.css` added to precompile list

## Key files
- `config/routes.rb` — all resource routes
- `app/models/ability.rb` — CanCanCan permissions
- `app/models/monthly_report.rb` — AASM workflow + events allowed per role
- `app/services/monthly_reports/trigger_event_service.rb` — state transition logic
- `app/uploaders/source_file_uploader.rb` — file upload config
- `config/initializers/carrierwave.rb` — S3 credentials (production only)
- `config/initializers/wicked_pdf.rb` — PDF generation settings
