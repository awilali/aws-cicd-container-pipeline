#!/bin/bash

apt update -y
apt upgrade -y

# Install SSM Agent (if not already present)
snap install amazon-ssm-agent --classic

systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service

# Install Docker
apt install -y docker.io

# Start Docker
systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

# AWS CLI installation

apt-get install -y awscli

# verify

docker --version
aws --version