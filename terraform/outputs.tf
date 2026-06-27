output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ec2_public_1_ip" {
  value = module.ec2-ecr.ec2_public_1_ip
}

output "instance_id" {
  value = module.ec2-ecr.instance_id
}

# output "ec2_name" {
#   value = module.ec2.ec2_name
# }

output "public_subnet_1_id" {
  value = module.subnets.public_subnet_1_id
}

output "public_subnet_2_id" {
  value = module.subnets.public_subnet_2_id
}

output "private_subnet_1_id" {
  value = module.subnets.private_subnet_1_id
}

output "private_subnet_2_id" {
  value = module.subnets.private_subnet_2_id
}
