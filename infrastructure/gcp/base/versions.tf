terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.9"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.9"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
  required_version = "1.6.6"
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone

  default_labels = {
    managed-by = "terraform"
  }
}

provider "google-beta" {
  project = var.gcp_project_id
  region  = var.gcp_region

  default_labels = {
    managed-by = "terraform"
  }
}

provider "github" {
  owner = "Vizzuality"
}
