#!/bin/bash

apt update -y
apt install -y docker.io

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

# AWS CLI installation

apt-get install -y awscli

# verify

docker --version
aws --version