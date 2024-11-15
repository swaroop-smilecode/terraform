# Resource Block
# Resource-1: Create VPC
resource "aws_vpc" "generic_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "generic_vpc"
  }
}

# Note-1

# resource "aws_vpc" 
# This should be exactly as it is. Because in HCL lang, it is saying that 
# create resource named vpc by using the aws provider

# generic_vpc is the name of the vpc you are going to create.
