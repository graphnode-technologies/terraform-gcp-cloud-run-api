data "google_compute_default_service_account" "default" {
}

resource "google_cloud_run_service" "this" {
  name     = var.name
  location = var.location

  template {
    metadata {
      annotations = merge({
        "autoscaling.knative.dev/maxScale" = var.max_replicas
        "autoscaling.knative.dev/minScale" = var.min_replicas
      }, var.extra_annotations)
    }
    spec {
      service_account_name = data.google_compute_default_service_account.default.email
      containers {

        ports {
          name           = "http1"
          container_port = var.port
        }

        image = var.image_url

        dynamic "env" {
          for_each = nonsensitive(keys(var.environment_vars))
          content {
            name  = env.value
            value = var.environment_vars[env.value]
          }
        }

        resources {
          limits   = var.limits
          requests = var.requests
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
  autogenerate_revision_name = true
}

resource "google_cloud_scheduler_job" "keep_alive" {
  count       = var.keep_alive ? 1 : 0
  name        = "wake-up-${var.name}"
  description = "Used to keep instance warm for cloud run ${var.name}"
  schedule    = var.cron_schedule
  time_zone   = "America/Sao_Paulo"

  http_target {
    http_method = "GET"
    uri         = "https://${var.domain_name}/"
  }
}

resource "google_cloud_run_domain_mapping" "this" {
  count = var.domain_name != "" ? 1 : 0
  location = var.location
  name     = var.domain_name

  metadata {
    namespace = var.namespace
  }
  spec {
    route_name = google_cloud_run_service.this.name
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.this.location
  project     = google_cloud_run_service.this.project
  service     = google_cloud_run_service.this.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
