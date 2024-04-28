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
