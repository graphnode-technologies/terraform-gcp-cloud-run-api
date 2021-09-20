output "resource_records" {
  value = var.domain_name != "" ? google_cloud_run_domain_mapping.this.0.status.0.resource_records : []
}