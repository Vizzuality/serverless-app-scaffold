locals {
  domain = var.subdomain == "" ? var.domain : "${var.subdomain}.${var.domain}"
}

resource "random_string" "random_string" {
  length = 4
  keepers = {
    name = var.name
  }
  special = false
  upper   = false
}

resource "google_project_service" "compute_engine_api" {
  service            =  "compute.googleapis.com"
  disable_on_destroy = false
}

// IP address
resource "google_compute_global_address" "ip_address" {
  name         = "${var.name}-lb"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"

  # to enable Compute Engine API
  depends_on = [ google_project_service.compute_engine_api ]
}

# --------------------------
# HTTP redirection to HTTPS
# --------------------------
resource "google_compute_global_forwarding_rule" "http-redirect" {
  name       = "${var.name}-http-redirect"
  target     = google_compute_target_http_proxy.http-redirect.self_link
  ip_address = google_compute_global_address.ip_address.address
  port_range = "80"

  depends_on = [ google_project_service.compute_engine_api ]
}

resource "google_compute_target_http_proxy" "http-redirect" {
  name    = "${var.name}-http-redirect"
  url_map = google_compute_url_map.http-redirect.self_link
}

resource "google_compute_url_map" "http-redirect" {
  name = "${var.name}-http-redirect"

  default_url_redirect {
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT" // 301 redirect
    strip_query            = false
    https_redirect         = true // this is the magic
  }
}

# ------------------------------------------------------------------------------
# HTTPS Load balancer config with certificate handling
# ------------------------------------------------------------------------------
resource "google_compute_managed_ssl_certificate" "load-balancer-certificate" {
  name = "${var.name}-lb-cert-${random_string.random_string.result}"

  managed {
    domains = [local.domain]
  }


  depends_on = [ google_project_service.compute_engine_api ]
  lifecycle {
    //This is option is to be able to update SSL certificates https://github.com/hashicorp/terraform/issues/10546 https://github.com/hashicorp/terraform-provider-google/issues/5356
    create_before_destroy = true
  }
}

resource "google_compute_global_forwarding_rule" "load-balancer-forwarding-rule-https" {
  name                  = "${var.name}-lb-forwarding-rule-https"
  target                = google_compute_target_https_proxy.load-balancer-https-proxy.id
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.ip_address.address
}

resource "google_compute_target_https_proxy" "load-balancer-https-proxy" {
  name             = "${var.name}-lb-https-proxy"
  url_map          = google_compute_url_map.load-balancer-url-map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.load-balancer-certificate.id]
}

resource "google_compute_url_map" "load-balancer-url-map" {
  name            = "${var.name}-lb"
  description     = "Load balancer for ${var.name}"
  default_service = google_compute_backend_service.frontend_service.id

  host_rule {
    hosts        = [local.domain]
    path_matcher = "site"
  }

  path_matcher {
    name            = "site"
    default_service = google_compute_backend_service.frontend_service.id

    path_rule {
      paths   = ["/${var.backend_path_prefix}/*"]
      service = google_compute_backend_service.backend_service.id
      route_action {
        url_rewrite {
          path_prefix_rewrite = "/"
        }
      }
    }

    path_rule {
      paths   = ["/${var.cloud_functions_path_prefix}/${var.function_path_prefix}/*"]
      service = google_compute_backend_service.cloud_function_service.id
      route_action {
        url_rewrite {
          path_prefix_rewrite = "/"
        }
      }
    }
  }
}

# -------------------------------------
# Load balancer backend defintion
# -------------------------------------
resource "google_compute_backend_service" "backend_service" {
  name        = "${var.name}-backend-service"
  description = "${var.name} backend service (API and CMS)"

  backend {
    group = google_compute_region_network_endpoint_group.cloudrun_backend_neg.id
  }
}

resource "google_compute_backend_service" "frontend_service" {
  name        = "${var.name}-frontend-service"
  description = "${var.name} frontend service"

  backend {
    group = google_compute_region_network_endpoint_group.cloudrun_frontend_neg.id
  }
}

resource "google_compute_backend_service" "cloud_function_service" {
  name        = "${var.name}-cloudfunction-service"
  description = "${var.name} cloud function service"

  /*
  // CDN can be enabled at Backend Service level to cache responses, depending on needs
  enable_cdn = true

  cdn_policy {
    cache_key_policy {
      include_query_string = true
    }
    cache_mode  = "FORCE_CACHE_ALL"
    default_ttl = 604800 // 1 week, this could potentially be increased, since maps are bound to remain unchanged
  }
  */

  backend {
    group = google_compute_region_network_endpoint_group.cloud_function_neg.id
  }
}

resource "google_compute_region_network_endpoint_group" "cloudrun_backend_neg" {
  provider              = google-beta
  name                  = "${var.name}-backend-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.backend_cloud_run_name
  }
}

resource "google_compute_region_network_endpoint_group" "cloudrun_frontend_neg" {
  provider              = google-beta
  name                  = "${var.name}-frontend-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.frontend_cloud_run_name
  }
}

resource "google_compute_region_network_endpoint_group" "cloud_function_neg" {
  provider              = google-beta
  name                  = "${var.name}-function-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_function {
    function = var.cloud_function_name
  }
}

#---------------------------------------
# DNS record
resource "google_dns_record_set" "frontend-dns-record-set" {
  project      = var.project
  name         = "${local.domain}."
  type         = "A"
  ttl          = 3600
  managed_zone = var.dns_managed_zone_name
  rrdatas      = [google_compute_global_address.ip_address.address]
}
