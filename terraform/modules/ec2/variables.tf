
# variable "ec2_name" {
#   type = string
# }

variable "public_subnet_1_id" {
  description = "Public subnet 1 ID"
  type        = string
}

variable "public_subnet_2_id" {
  description = "Public subnet 2 ID"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for EC2"
  type        = string
}

variable "key_pair_name" {
  description = "AWS key pair name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
