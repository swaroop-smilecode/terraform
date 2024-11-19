# Resources Blocks

# Resource-1: Create VPC
resource "aws_vpc" "vpc-dev" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "vpc-dev"
  }
}

# Resource-2: Create Subnets
resource "aws_subnet" "vpc-dev-public-subnet-1" {
  vpc_id            = aws_vpc.vpc-dev.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  # When i launch ec2 instance inside this public subnet,
  # if i need to tell to aws, that you your self assign an random IP address to ec2 server,
  # this is the way to do so.
  map_public_ip_on_launch = true
}

# Resource-3: Internet Gateway
# If you want an end user to reach your subnet from internet, the subnet should be public subnet.
# How to make subnet a public subnet?
# Just attach an Internet gateway to subnet & subnet becomes public subnet.
resource "aws_internet_gateway" "vpc-dev-igw" {
  vpc_id = aws_vpc.vpc-dev.id
}

# Resource-4: Route Table
resource "aws_route_table" "vpc-dev-public-route-table" {
  # Route table needs to be associated with subnet, which will do in the next step, but, first of all
  # you should tell inside which VPC, this route table is getting created. For that purpose, will mention vpc_id
  vpc_id = aws_vpc.vpc-dev.id
}

# Resource-5: Associate route Table with the Subnet
resource "aws_route_table_association" "vpc-dev-public-route-table-associate" {
  route_table_id = aws_route_table.vpc-dev-public-route-table.id
  subnet_id      = aws_subnet.vpc-dev-public-subnet-1.id
}

# Resource-6: Create route in Route Table for Internet Access
resource "aws_route" "vpc-dev-public-route" {
  route_table_id         = aws_route_table.vpc-dev-public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc-dev-igw.id
}

# Resource-7: Security Group
resource "aws_security_group" "dev-vpc-sg" {
  name        = "dev-vpc-default-sg"
  description = "Dev VPC Default Security Group"
  # Again, security group is present inside the VPC, hence we need to associate 
  # security group with VPC.
  vpc_id = aws_vpc.vpc-dev.id

  # What is Ingress?
  # Ingress, conversely, pertains to the flow of data into a private network from an external source, 
  # typically the public internet.
  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # What is Egress?
  # Egress refers to the flow of data moving out of a private network into the public internet 
  # or another external network. 
  egress {
    description = "Allow all IP and Ports Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
