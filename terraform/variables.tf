variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "key_pair_name" {
  description = "Name of your existing AWS key pair"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# variable "ec2_name" {
#   type = string
# }
