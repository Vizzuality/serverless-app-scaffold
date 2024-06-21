variable "project" {
  type        = string
  description = "The GCP project to deploy service into"
}

variable "region" {
  type        = string
  description = "The GCP region to deploy service into"
}

variable "name" {
  type        = string
  description = "Name to use on resources"
}

variable "dns_managed_zone_name" {
  type        = string
  description = "Name of the DNS Zone"
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

variable "frontend_cloud_run_name" {
  type        = string
  description = "Name of the frontend Cloud Run service"
}

variable "backend_cloud_run_name" {
  type        = string
  description = "Name of the backend Cloud Run service"
}

variable "cloud_function_name" {
  type = string
  description = "Name of the Cloud Function service"
}

variable "backend_path_prefix" {
  type        = string
  description = "Path prefix for the backend service"
}

variable "cloud_functions_path_prefix" {
  type        = string
  description = "Base Path prefix for the cloud function backend service"
}

variable "function_path_prefix" {
  type        = string
  description = "Specific Path prefix for the cloud function backend service"
}
