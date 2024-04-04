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
