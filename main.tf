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
  url          = format("https://%s.console.ves.volterra.io/api", var.tenant)
  api_p12_file = var.api_p12_path
}

resource "volterra_origin_pool" "gcp-origin" {
  name                   = format("gcp-%s-tf", var.shortname)
  namespace              = var.namespace
  description            = "Created by Terraform"
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"

  port   = var.origin_port
  no_tls = true

  origin_servers {
    private_ip {
      ip              = var.origin_ip
      outside_network = true
      site_locator {
        site {
          tenant    = null
          namespace = "system"
          name      = var.origin_site
        }
      }
    }
  }
}