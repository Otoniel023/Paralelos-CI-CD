output "cloud_run_url" {
  description = "URL del servicio Cloud Run"
  value       = google_cloud_run_v2_service.api.uri
}

output "api_gateway_url" {
  description = "URL del API Gateway - usar esta en la app Flutter"
  value       = "https://${google_api_gateway_gateway.gateway.default_hostname}"
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

output "notification_cloud_run_url" {
  description = "URL del Cloud Run de notificaciones"
  value       = google_cloud_run_v2_service.notifications.uri
}

output "pubsub_topic" {
  description = "Nombre del topic Pub/Sub"
  value       = google_pubsub_topic.notifications.name
}
