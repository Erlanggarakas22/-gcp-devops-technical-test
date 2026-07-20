variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  type        = string
  default     = "asia-southeast2"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "devops-test-app"
}

variable "database_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "appdb"
}

variable "database_user" {
  description = "PostgreSQL application user"
  type        = string
  default     = "appuser"
}

variable "container_image" {
  description = "Initial container image for Cloud Run"
  type        = string
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "alert_email" {
  description = "Email address for monitoring notifications"
  type        = string
}
