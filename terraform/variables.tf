variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "key_pair_name" {
  description = "Name of your existing AWS key pair"
  type        = string
}

# variable "ec2_name" {
#   type = string
# }
