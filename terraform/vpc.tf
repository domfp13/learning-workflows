# Create data: data is a way to fetch information from the provider at run time.
data "aws_availability_zones" "available" {}

# Define the locals, locals are a way to define a named expression that can be used multiple times within a module without needing to repeat the expression. 
# Once a local value is defined, it cannot be overridden or changed. (similar to varialbles) 
locals {
  name     = "workflow"
  vpc_cidr = "10.0.0.0/16"

  tags = {
    Name      = local.name
    Blueprint = local.name
    Owner     = "Enrique Plata"
  }
}

// *************** VPC ***************
resource "aws_vpc" "workflow_vpc" {
  cidr_block           = local.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name  = "${local.name}-vpc"
    Owner = local.tags.Owner
  }
}

// *************** Internet Gateway ***************
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.workflow_vpc.id

  tags = {
    Name = "${local.name}-igw"
  }
}

// *************** Subnets ***************
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.workflow_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true // Auto-assign public IPV4 IPs on launch

  tags = {
    Owner = local.tags.Owner
    Name  = "${local.name}-public-subnet"

  }
}

// *************** Route Table(s) ***************

# // Adding tags to the default route table created by the VPC
# resource "aws_default_route_table" "default" {
#   default_route_table_id = aws_vpc.workflow_vpc.default_route_table_id

#   tags = {
#     Name = "${local.name}-default-rtb"
#   }
# }

// Creating a new route table for the public subnet 
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.workflow_vpc.id

  tags = {
    Name = "${local.name}-public-rtb"
  }
}

// Creating a route to the internet gateway using our route table
resource "aws_route" "public_internet_access_route_a" {
  route_table_id         = aws_route_table.public-rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

// Associating the subnet with the public route table
resource "aws_route_table_association" "public-rtb-assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public-rtb.id
}

// *************** Network ACLs ***************
# resource "aws_default_network_acl" "default" {
#   default_network_acl_id = aws_vpc.workflow_vpc.default_network_acl_id

#   tags = {
#     Name = "${local.name}-default-nacl"
#   }
# }

// TODO: Use the aws_security_group created as default