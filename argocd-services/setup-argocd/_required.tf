# ==================================================================
# TERRAFORM REQUIRED CONFIGURATION
# ==================================================================

terraform {
  required_version = ">= 1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.73"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.16"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
