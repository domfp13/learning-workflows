terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.0"
    }
  }
}

# Specify the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create data: data is a way to fetch information from the provider at run time.
data "aws_availability_zones" "available" {}

# Define the locals, locals are a way to define a named expression that can be used multiple times within a module without needing to repeat the expression. 
# Once a local value is defined, it cannot be overridden or changed. (similar to varialbles) 
locals {
  name = "workflow-vpc"

  vpc_cidr = "10.0.0.0/23"

  tags = {
    Name       = local.name
    Blueprint  = local.name
    GithubRepo = "https://github.com/domfp13/learning-workflows"
    Owner      = "Enrique Plata"
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = local.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = local.tags
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = local.tags
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = local.tags
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.my_vpc.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_vpc.my_vpc.main_route_table_id]
}

