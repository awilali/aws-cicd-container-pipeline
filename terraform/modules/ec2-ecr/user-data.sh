#!/bin/bash

apt update -y

apt install -y snapd

# SSM Agent
snap install amazon-ssm-agent --classic
systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service

# Docker
apt install -y docker.io
systemctl enable docker
systemctl start docker

# AWS CLI
apt install -y awscli

# Real validation
aws sts get-caller-identity

# FINAL READY SIGNAL
touch /var/lib/cloud/instance/user-data-finished
