## Project Architecture Diagram

![Architecture Diagram](images/project-architecture.jpg)

# CI/CD Pipeline for Containerized App on AWS EC2 using Terraform & GitHub Actions

The system automates infrastructure provisioning and application deployment from GitHub to AWS using Terraform and GitHub Actions.

## Overview

This project demonstrates a fully automated CI/CD pipeline deploying a Dockerized application to AWS EC2 using Terraform and GitHub Actions with secure OIDC authentication (no long-lived credentials).

It showcases real-world DevOps practices including Infrastructure as Code, containerization, and secure cloud deployment workflows.

⚙️ How It Works
1. Infrastructure Provisioning (Terraform)
- Creates VPC, subnets, security groups
- Provisions EC2 instance
- Sets up ECR repository
- Configures IAM roles and policies
- Stores Terraform state in S3 with DynamoDB locking

2. CI/CD Pipeline (GitHub Actions)
- Triggered on push to main
- Authenticates to AWS using OIDC
- Builds Docker image
- Pushes image to Amazon ECR

3. Deployment
- EC2 pulls latest image from ECR
- Runs container using Docker
- Application is exposed via EC2 public IP

🧰 Tech Stack
- Terraform (Infrastructure as Code)
- AWS (EC2, VPC, IAM, ECR, S3, DynamoDB)
- Docker
- GitHub Actions (CI/CD)
- Linux (Ubuntu EC2)
- VS Code

🔐 Security Highlights
- No AWS access keys stored in GitHub
- Secure authentication via OIDC
- Least-privilege IAM roles
- Remote state stored securely in S3 with locking

Terraform File Structure:

AWS-CICD-CONTAINER-PIPELINE/
│
├── backend/
│   ├── .terraform.lock.hcl
│   ├── bootstrap.tf
│   ├── providers.tf
│   ├── terraform.tfstate
│   └── terraform.tfstate.backup
│
├── docker-app/
│   ├── Dockerfile
│   └── index.html
│
├── images/
│   └── project-architecture.jpg
│
├── terraform/
│   ├── .terraform/
│   │
│   ├── modules/
│   │   ├── ec2/
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── user-data.sh
│   │   │   └── variables.tf
│   │   │
│   │   ├── security_groups/
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   │
│   │   ├── subnets/
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   │
│   │   └── vpc/
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       └── variables.tf
│   │
│   ├── .terraform.lock.hcl
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── terraform.tfvars
│   └── variables.tf
│
├── .gitignore
└── README.md

The project is ongoing and will b

