terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # backend code

  backend "s3" {
    bucket       = "devops-project-s3bucket-eleanor"
    key          = "terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true

    encrypt = true
  }
}

provider "aws" {
  region = "us-east-2"
}
