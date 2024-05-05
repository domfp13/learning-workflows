#!/bin/bash

# Update the installed packages and package cache on your instance
sudo yum update -y
sudo yum install git -y

# Install the most recent Docker Community Edition package
sudo amazon-linux-extras install -y docker

# Start the Docker service
sudo service docker start

# Add the ec2-user to the docker group so you can execute Docker commands without using sudo
sudo usermod -a -G docker ec2-user

# Get the latest version of Docker Compose
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Apply executable permissions to the Docker Compose binary
sudo chmod +x /usr/local/bin/docker-compose

# Start Docker on boot
sudo chkconfig docker on

# Log in to the EC2 repository and getting dynamically the account_id
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query Account --output text).dkr.ecr.us-east-1.amazonaws.com

# PUlling the ECR image from the the repository
docker pull $(aws sts get-caller-identity --query Account --output text).dkr.ecr.us-east-1.amazonaws.com/prefect-workflow-ecr-repository:latest

# Tagging the image
docker tag $(aws sts get-caller-identity --query Account --output text).dkr.ecr.us-east-1.amazonaws.com/prefect-workflow-ecr-repository:latest prefect:latest

# Running the container
docker run -d -p 80:80 prefect:latest
