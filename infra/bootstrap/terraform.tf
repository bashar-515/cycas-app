terraform {
  required_version = ">= 1.10.7"

  required_providers {
    tfe = {
      source = "hashicorp/tfe"
      version = "~> 0.71.0"
    }
  }
}
