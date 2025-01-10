terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "= 3.0.1"
    }
    google = {
      source  = "hashicorp/google"
      version = "= 6.15.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "= 6.15.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "= 4.5.0"
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

provider "docker" {
  registry_auth {
    address     = "us-docker.pkg.dev"
    config_file = pathexpand("~/.docker/config.json")
  }
}

module "vault" {
  source = "git::https://github.com/LibOps/terraform-vault-cloudrun?ref=171626a2fb1ddaa47e700b17ecbad30b7a9ae082"
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
