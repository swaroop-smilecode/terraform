# --------------------------------------
# Create VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "yt-vpc"
  }
}
# --------------------------------------

# Create 2 public subnets & 2 private subnets.
# First i am creating an variable with the values of Availability zones.
variable "vpc_availability_zones" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
}

# Create 2 public subnets
# This block executes 2 times & will see what the CIDR block will be for each iteration.
# cidr_block = "10.0.0.0/16"
# cidrsubnet("10.0.0.0/16", 8, 0 + 1) => cidrsubnet("10.0.0.0/16", 8, 1) => "10.0.1.0/24"
# cidrsubnet("10.0.0.0/16", 8, 1 + 1) => cidrsubnet("10.0.0.0/16", 8, 2) => "10.0.2.0/24"
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.custom_vpc.id
  count             = length(var.vpc_availability_zones)
  cidr_block        = cidrsubnet(aws_vpc.custom_vpc.cidr_block, 8, count.index + 1)
  availability_zone = element(var.vpc_availability_zones, count.index)
  tags = {
    Name = "YT Public subnet ${count.index + 1}"
  }
}

# Create 2 private subnets
# cidr_block = "10.0.0.0/16"
# cidrsubnet("10.0.0.0/16", 8, 0 + 3) => cidrsubnet("10.0.0.0/16", 8, 1) => "10.0.3.0/24"
# cidrsubnet("10.0.0.0/16", 8, 1 + 3) => cidrsubnet("10.0.0.0/16", 8, 2) => "10.0.4.0/24"
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.custom_vpc.id
  count             = length(var.vpc_availability_zones)
  cidr_block        = cidrsubnet(aws_vpc.custom_vpc.cidr_block, 8, count.index + 3)
  availability_zone = element(var.vpc_availability_zones, count.index)
  tags = {
    Name = "YT Private subnet ${count.index + 1}"
  }
}
# --------------------------------------

# Internet Gateway
resource "aws_internet_gateway" "igw_vpc" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "YT-Internet Gateway"
  }
}
# --------------------------------------

# Create route table for public subnets
resource "aws_route_table" "yt_route_table_public_subnet" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"                     # Source
    gateway_id = aws_internet_gateway.igw_vpc.id # Destination
  }
  tags = {
    Name = " Public subnet Route Table"
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "public_subnet_association" {
  route_table_id = aws_route_table.yt_route_table_public_subnet.id
  count          = length(var.vpc_availability_zones)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
}
# --------------------------------------

# Elastic IP
resource "aws_eip" "eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw_vpc] # Internet gateway should present before creating Elastic IP.
}
# --------------------------------------

# NAT Gateway
resource "aws_nat_gateway" "yt-nat-gateway" {
  subnet_id     = element(aws_subnet.private_subnet[*].id, 0) # Deploying NAT gateway only on first subnet.
  allocation_id = aws_eip.eip.id
  depends_on    = [aws_internet_gateway.igw_vpc]
  tags = {
    Name = "YT-Nat Gateway"
  }
}
# --------------------------------------

# Route table for Private subnets
resource "aws_route_table" "yt_route_table_private_subnet" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"                       # source
    gateway_id = aws_nat_gateway.yt-nat-gateway.id # destination
  }
  depends_on = [aws_nat_gateway.yt-nat-gateway]
  tags = {
    Name = " Private subnet Route Table"
  }
}

# Route table association with private subnets
resource "aws_route_table_association" "private_subnet_association" {
  route_table_id = aws_route_table.yt_route_table_private_subnet.id
  count          = length(var.vpc_availability_zones)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
}
# --------------------------------------
