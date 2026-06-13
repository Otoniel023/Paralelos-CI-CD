output "cloud_run_url" {
  description = "URL del servicio Cloud Run"
  value       = google_cloud_run_v2_service.api.uri
}

output "artifact_registry_url" {
  description = "URL del Artifact Registry"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/docker-repo"
}

output "cloud_sql_connection" {
  description = "Nombre de conexion Cloud SQL"
  value       = google_sql_database_instance.postgres.connection_name
}

output "storage_bucket" {
  description = "Bucket para uploads"
  value       = google_storage_bucket.uploads.name
}

output "cloud_run_sa" {
  description = "Service Account de Cloud Run"
  value       = google_service_account.cloud_run_sa.email
}
