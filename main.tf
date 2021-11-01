terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.10.0"
    }
  }
}

provider "volterra" {
  # Configuration options.
  url          = format("https://%s.console.ves.volterra.io/api", var.TENANT)
  api_p12_file = var.API_P12_PATH
}

resource "volterra_origin_pool" "gcp-origin" {
  name                   = format("gcp-%s-tf", var.SHORTNAME)
  namespace              = var.NAMESPACE
  description            = "Created by Terraform"
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"

  port   = var.ORIGIN_PORT
  no_tls = true

  origin_servers {
    private_ip {
      ip              = var.ORIGIN_IP
      outside_network = true
      site_locator {
        site {
          tenant    = null
          namespace = "system"
          name      = var.ORIGIN_SITE
        }
      }
    }
  }
}