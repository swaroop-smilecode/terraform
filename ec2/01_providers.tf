# Terraform Block
terraform {
  required_version = "1.9.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.76.0"
    }
  }
}

# Provider Block
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}
