terraform {
  required_version = ">= 1.10.7"

  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "5.14.0"
    }
  }

  cloud {
    organization = "Cycas-01"
    hostname = "app.terraform.io"

    workspaces {
      name = "site-production"
    }
  }
}
