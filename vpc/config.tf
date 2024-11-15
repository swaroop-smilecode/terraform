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


# Note-1

# In general, profile is nothing but set of configuration settings(key–value pairs) which also includes 
# username & password.

# In the same way, AWS profile is a set of configuration settings(key–value pairs) which also includes 
# username & password, that are used by the AWS CLI / AWS SDKs.
