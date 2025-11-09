terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
    google = {
      source  = "hashicorp/google"
      version = "7.10.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "7.10.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "4.8.0"
    }
  }

  backend "gcs" {
    bucket = "libops-vault-terraform"
    prefix = "/github"
  }
}

provider "google" {
  project = var.project
}

provider "google-beta" {
  project = var.project
}

provider "docker" {
  registry_auth {
    address     = "us-docker.pkg.dev"
    config_file = pathexpand("~/.docker/config.json")
  }
}

locals {
  ci_gsa = "github@${var.project}.iam.gserviceaccount.com"
}

module "vault" {
  source = "git::https://github.com/libops/terraform-vault-cloudrun?ref=0.0.6"
  providers = {
    docker      = docker
    google      = google
    google-beta = google-beta
  }
  project    = var.project
  region     = var.region
  init_image = "jcorall/vault-init:0.4.0"
}

provider "vault" {
  address = module.vault.vault-url
}
