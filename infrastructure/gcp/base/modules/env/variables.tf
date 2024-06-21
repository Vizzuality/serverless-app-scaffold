variable "github_org" {
  type        = string
  description = "Github organization"
}

variable "github_project" {
  type        = string
  description = "Github project name"
}

variable "github_branch" {
  type        = string
  description = "Github project branch"
}

variable "project_name" {
  type        = string
  description = "Name of the project"
}

# define GCP region
variable "gcp_region" {
  type        = string
  description = "GCP region"
}

# define GCP project id
variable "gcp_project_id" {
  type        = string
  description = "GCP project id"
}

variable "tf_state_prefix" {
  type        = string
  default     = "state"
  description = "The prefix for the TF state in the Google Storage Bucket"
}

variable "dns_zone_name" {
  type        = string
  description = "Name for the GCP DNS Zone"
}

variable "domain" {
  type        = string
  description = "Base domain for the DNS zone"
}

variable "subdomain" {
  type        = string
  default     = ""
  description = "If set, it will be prepended to the domain to form a subdomain."
}

variable "frontend_min_scale" {
  type        = number
  description = "Minimum number of frontend app instances to deploy"
  default     = 0
}

variable "frontend_max_scale" {
  type        = number
  description = "Maximum number of frontend app instances to deploy"
  default     = 5
}

variable "backend_min_scale" {
  type        = number
  description = "Minimum number of backend app instances to deploy"
  default     = 0
}

variable "backend_max_scale" {
  type        = number
  description = "Maximum number of backend app instances to deploy"
  default     = 5
}

variable "cors_origin" {
  type        = string
  description = "Origin for CORS config"
  default     = "*"
}

variable "uptime_alert_email" {
  type        = string
  description = "Email address to which uptime alerts should be sent"
}

variable "environment" {
  type        = string
  description = "staging | production"
}

variable "database_name" {
  type        = string
  description = "Name of the database"
}

variable "database_user" {
  type        = string
  description = "Name of the database user"
}

variable "backend_path_prefix" {
  type        = string
  description = "Path prefix for the backend service"
}


variable "cloud_functions_path_prefix" {
  type        = string
  description = "Path prefix for the functions services"
}

variable "function_path_prefix" {
  type        = string
  description = "Path prefix for the Cloud Function"
}

variable "function_timeout_seconds" {
  type        = number
  default     = 180
  description = "Timeout for the Cloud Function"
}

variable "function_available_memory" {
  type        = string
  default     = "256M"
  description = "Available memory for the Cloud Function"
}

variable "function_available_cpu" {
  type        = number
  default     = 1
  description = "Available cpu for the Cloud Function"
}

variable "function_min_instance_count" {
  type        = number
  default     = 0
  description = "Min instance count for the Cloud Function"
}

variable "function_max_instance_count" {
  type        = number
  default     = 1
  description = "Max instance count for the Cloud Function"
}

variable "function_max_instance_request_concurrency" {
  type        = number
  default     = 80
  description = "Max instance request concurrency for the Cloud Function"
}
