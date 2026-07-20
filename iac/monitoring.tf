locals {
  cloud_run_host = trimsuffix(
    trimprefix(google_cloud_run_v2_service.app.uri, "https://"),
    "/"
  )
}

resource "google_monitoring_notification_channel" "email" {
  display_name = "DevOps Technical Test Email"
  type         = "email"

  labels = {
    email_address = var.alert_email
  }

  depends_on = [
    google_project_service.required
  ]
}

resource "google_monitoring_uptime_check_config" "healthz" {
  display_name = "${var.app_name}-${var.environment}-healthz"
  timeout      = "10s"
  period       = "60s"

  monitored_resource {
    type = "uptime_url"

    labels = {
      project_id = var.project_id
      host       = local.cloud_run_host
    }
  }

  http_check {
    path         = "/healthz"
    port         = 443
    use_ssl      = true
    validate_ssl = true
  }

  checker_type = "STATIC_IP_CHECKERS"
}

resource "google_monitoring_alert_policy" "healthz_failure" {
  display_name = "${var.app_name}-${var.environment}-healthz-failure"
  combiner     = "OR"

  conditions {
    display_name = "Health check fails continuously for five minutes"

    condition_threshold {
      filter = join(" AND ", [
        "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\"",
        "resource.type=\"uptime_url\"",
        "metric.label.check_id=\"${google_monitoring_uptime_check_config.healthz.uptime_check_id}\""
      ])

      comparison      = "COMPARISON_LT"
      threshold_value = 1
      duration        = "300s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_NEXT_OLDER"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email.name
  ]

  documentation {
    mime_type = "text/markdown"

    content = <<-EOT
      The Cloud Run `/healthz` endpoint failed continuously for five minutes.

      Investigation steps:

      1. Check the active Cloud Run revision.
      2. Review Cloud Run application logs.
      3. Verify Cloud SQL connectivity.
      4. Review request latency, memory, CPU, and error metrics.
    EOT
  }
}
