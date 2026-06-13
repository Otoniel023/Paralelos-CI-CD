project_id      = "paralelos-cicd"
region          = "us-central1"
app_name        = "paralelos-api"
cloud_run_image = "us-central1-docker.pkg.dev/paralelos-cicd/docker-repo/paralelos-api:latest"
db_name         = "calzado_db"
db_user         = "appuser"

# Estos valores los inyecta el pipeline desde GitHub Secrets
# No los pongas aqui en produccion
db_password = "REEMPLAZAR_CON_GITHUB_SECRET"
jwt_secret  = "REEMPLAZAR_CON_GITHUB_SECRET"
