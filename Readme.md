# Paralelos API - CI/CD con Google Cloud Platform

API REST para sistema de calzado con autenticación JWT, CRUD de usuarios y upload de archivos. Desplegada automáticamente en Google Cloud Platform usando GitHub Actions y Terraform.

## Arquitectura

```
App Móvil (Flutter)
        ↓
Cloud Run (API Node.js)
        ↓
Cloud SQL (PostgreSQL 15)
```

## Pipeline CI/CD

Cada push a `main` dispara automáticamente:

```
git push origin main
        ↓
GitHub Actions
        ├── Build & Test (npm ci + npm test)
        ├── Docker Build & Push → Artifact Registry
        └── Deploy → Cloud Run
```

## Infraestructura en GCP (Terraform)

| Recurso | Descripción |
|---------|-------------|
| Cloud Run | Servidor serverless donde corre la API |
| Cloud SQL PostgreSQL 15 | Base de datos en la nube |
| Artifact Registry | Registro privado de imágenes Docker |
| Secret Manager | Almacena contraseñas y JWT secret |
| Storage Bucket | Almacenamiento de archivos subidos |
| VPC + Cloud SQL Connector | Red privada para la base de datos |
| Cloud Logging | Logs del servicio en producción |
| Service Account + IAM | Permisos mínimos por servicio |

## Stack tecnológico

- **Runtime:** Node.js 20
- **Framework:** Express.js
- **Base de datos:** PostgreSQL 15 (Cloud SQL)
- **Autenticación:** JWT
- **Arquitectura:** SOLID (Domain, Application, Infrastructure, Interfaces)
- **Contenedor:** Docker (imagen Alpine)
- **IaC:** Terraform
- **CI/CD:** GitHub Actions + Workload Identity Federation
- **Cloud:** Google Cloud Platform

## Endpoints

| Método | Endpoint | Auth | Descripción |
|--------|----------|------|-------------|
| POST | `/api/auth/login` | No | Login de usuario |
| POST | `/api/auth/register` | No | Registro de usuario |
| GET | `/api/users` | JWT | Listar usuarios |
| POST | `/api/users` | JWT | Crear usuario |
| GET | `/api/users/:id` | JWT | Obtener usuario |
| PUT | `/api/users/:id` | JWT | Actualizar usuario |
| DELETE | `/api/users/:id` | JWT | Eliminar usuario |
| POST | `/api/files/upload` | JWT | Subir archivo |
| GET | `/health` | No | Health check |

## Estructura del proyecto

```
Paralelos-CI-CD/
├── src/
│   ├── application/        # Casos de uso
│   ├── config/
│   │   └── database.js     # Conexión PostgreSQL
│   ├── domain/             # Entidades y contratos
│   ├── infrastructure/     # Repositorios MySQL/PG
│   ├── interfaces/         # Controladores y rutas
│   └── index.js            # Entrada de la app
├── terraform/
│   ├── main.tf             # Recursos GCP
│   ├── variables.tf        # Variables
│   ├── outputs.tf          # Outputs
│   ├── provider.tf         # Provider Google
│   └── terraform.tfvars    # Valores
├── .github/
│   └── workflows/
│       └── deploy.yml      # Pipeline CI/CD
├── schema.sql              # Schema PostgreSQL
├── Dockerfile              # Imagen Docker
└── .env.example            # Variables de entorno de ejemplo
```

## Variables de entorno

| Variable | Descripción | Entorno |
|----------|-------------|---------|
| `DB_HOST` | Host de la base de datos | Local |
| `DB_PORT` | Puerto de la base de datos | Local |
| `DB_USER` | Usuario de la base de datos | Ambos |
| `DB_PASSWORD` | Contraseña de la base de datos | Ambos |
| `DB_NAME` | Nombre de la base de datos | Ambos |
| `DB_SOCKET_PATH` | Socket Unix para Cloud SQL | GCP |
| `JWT_SECRET` | Clave secreta para JWT | Ambos |
| `JWT_EXPIRES_IN` | Expiración del token JWT | Ambos |
| `NODE_ENV` | Entorno de ejecución | Ambos |
| `PORT` | Puerto del servidor | Ambos |

## GitHub Secrets requeridos

| Secret | Descripción |
|--------|-------------|
| `WIF_PROVIDER` | Workload Identity Federation Provider |
| `WIF_SERVICE_ACCOUNT` | Service Account para el pipeline |
| `DB_PASSWORD` | Contraseña de la base de datos |
| `DB_USER` | Usuario de la base de datos |
| `DB_NAME` | Nombre de la base de datos |
| `JWT_SECRET` | Clave secreta JWT |

## Desarrollo local

```bash
# Instalar dependencias
npm install

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus valores locales

# Iniciar en modo desarrollo
npm run dev

# Iniciar en modo producción
npm start
```

## Despliegue

El despliegue es automático. Solo hace falta:

```bash
git add .
git commit -m "descripción del cambio"
git push origin main
```

GitHub Actions se encarga del resto. Puedes ver el progreso en la pestaña **Actions** del repositorio.