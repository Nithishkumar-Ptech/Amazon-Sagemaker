# Provider configuration
provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50.0"  # You can adjust to latest known compatible version
    }
  }

  required_version = ">= 1.3.0"
}
