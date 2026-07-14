# Asoquimbo Data Store

Plataforma de gestión de datos y reportes para el seguimiento de proyectos
socio-ecológicos. Permite catalogar caracterizaciones socio-ecológicas, registrar
informes mensuales con actividades, y administrar colaboradores, con un flujo de
aprobación basado en roles.

## Ruby version

Ruby **3.3.7** — ver `.ruby-version`.

## System dependencies

- **PostgreSQL** (14+ recomendado)
- **Node 18.0.0** (ver `.node-version`)
- **Yarn** (gestor de paquetes JS)
- **wkhtmltopdf** (incluido como gema `wkhtmltopdf-binary`)

## Configuration

### Variables de entorno

Copia `.env.example` (si existe) o configura las siguientes variables:

| Variable | Descripción |
|-|-|
| `RAILS_MASTER_KEY` | Llave maestra para desencriptar credenciales |
| `POSTGRES_HOST` | Host de la base de datos (producción) |
| `POSTGRES_DB` | Nombre de la base de datos (producción) |
| `POSTGRES_USER` | Usuario de PostgreSQL (producción) |
| `POSTGRES_PASSWORD` | Contraseña de PostgreSQL (producción) |

### Credenciales encriptadas

Editar con `bin/rails credentials:edit`. Las credenciales requeridas en producción:

```yaml
aws:
  access_key_id: "..."      # S3 sa-east-1
  secret_access_key: "..."
  bucket: "nombre-bucket"
gmail:
  user: "..."
  key: "..."                # App password de Gmail
server:
  production_host: "..."    # Host para links en emails
```

### Archivos subidos

- En **desarrollo/test**: almacenamiento local en `public/uploads/`
- En **producción**: AWS S3 (`sa-east-1`) vía `fog-aws`
- Tamaño máximo por archivo: **3 MB**
- Extensiones permitidas: `pdf doc docx xls xlsx csv png jpg jpeg`

## Database creation

```bash
bin/rails db:create
```

Las bases de datos configuradas en `config/database.yml`:
- `asoquimbo_data_store_development`
- `asoquimbo_data_store_test`
- `asoquimbo_data_store_production`

## Database initialization

```bash
bin/rails db:migrate
bin/rails db:seed
```

El seed crea un usuario administrador por defecto:
- Email: `xxxx@xxxx.com`
- Contraseña: `12345678`
- Rol: `admin`

## How to run the development server

```bash
# Inicia todos los procesos (web + JS + CSS)
bin/dev

# O inicia solo el servidor web
bin/rails server
```

Esto levanta:
- Servidor web en `http://localhost:3000`
- Compilación JS con esbuild (watch mode)
- Compilación CSS con Sass + autoprefixer (watch mode)

Todas las páginas requieren autenticación (Devise). La interfaz está en **español**.

## How to run the test suite

No existe un test suite. El proyecto no tiene directorio `test/` ni `spec/`.

## Lint y seguridad

```bash
bin/rubocop     # Estilo de código (rubocop-rails-omakase)
bin/brakeman    # Análisis de seguridad
```

Estos comandos se ejecutan en CI en cada push a `main` y pull request.

## Services (job queues, cache servers, search engines, etc.)

No se utilizan servicios adicionales. No hay Redis, workers de fondo, ni motor de búsqueda configurados. El envío de correo en producción usa Gmail SMTP.

## Deployment instructions

La aplicación está dockerizada (ver `Dockerfile`). El despliegue puede hacerse con:

```bash
docker build -t asoquimbo-data-store .
docker run -d -p 3000:3000 \
  -e RAILS_MASTER_KEY=<valor de config/master.key> \
  --name asoquimbo-data-store \
  asoquimbo-data-store
```

También compatible con **Kamal** para despliegue en VPS.

### Precompilación de assets

El `Dockerfile` precompila los assets durante el build:

```bash
SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile
```

Nota: `pdf.css` se agrega explícitamente a la lista de precompilación en `config/environments/production.rb`.

## Arquitectura

### Modelos principales

| Modelo | Descripción |
|-|-|
| `User` | Usuarios con roles (admin, director, coordinador, profesional, inspector) |
| `MonthlyReport` | Informes mensuales con flujo de estados AASM |
| `Activity` | Actividades asociadas a cada informe mensual |
| `SocialEcologicalCharacterization` | Catálogo de estudios/investigaciones |
| `Actor` | Registro de actores externos (colaboradores) |
| `CustomSelectList` | Sistema genérico de listas desplegables configurables |

### Flujo de aprobación de MonthlyReport

```
created → reported → approved ⇄ revised
```

- **Admin**: todos los eventos
- **Director/Coordinador**: `report`, `unreport`, `approve`, `unapprove`
- **Inspector**: `revise`, `unrevise`
- **Profesional**: `report`, `unreport`

Las transiciones se registran en el campo `transitions` (JSONB) con timestamp y usuario.
Cada transición se ejecuta mediante `MonthlyReports::TriggerEventService`.

### Estados de actividad

- Pendiente (0)
- En ejecución (1)
- Cumplida (2)

### Sistema de listas personalizadas

Los campos de tipo select (dropdowns) en los modelos se definen dinámicamente mediante
`CustomSelectList`. Cada modelo que use este sistema debe:

1. Tener `belongs_to :custom_select_list`
2. Declarar `OPTION_LISTABLE_FIELDS` con los campos que son listas
3. Existir un registro `CustomSelectList` con `model_name_association` igual al nombre del modelo

### Exportación a PDF

Los informes mensuales pueden exportarse a PDF mediante `wicked_pdf` + `wkhtmltopdf-binary`.
Configuración en `config/initializers/wicked_pdf.rb`.

## Stack técnico

| Tecnología | Versión |
|-|-|
| Ruby | 3.3.7 |
| Rails | 7.2.3 |
| Node | 18.0.0 |
| PostgreSQL | vía gema `pg` 1.6 |
| Bootstrap | 5.3 |
| Stimulus | 3.2 |
| Turbo | 8.0 |

### Gemas principales

| Gema | Propósito |
|-|-|
| `devise` 5.0 | Autenticación |
| `cancancan` 3.6 | Autorización por roles |
| `aasm` 5.5 | Máquina de estados para informes mensuales |
| `carrierwave` 3.1 | Carga de archivos |
| `fog-aws` 3.33 | Storage S3 en producción |
| `wicked_pdf` 2.8 | Exportación a PDF |
| `simple_form` 5.1 | Formularios |
| `letter_opener` | Vista previa de emails en desarrollo |
| `rails-i18n` | Traducciones al español |
