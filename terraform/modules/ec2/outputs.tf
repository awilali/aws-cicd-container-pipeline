output "ec2_public_1_ip" {
  value = aws_instance.ec2_public_1.public_ip
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

# output "ec2_public_2_ip" {
#   value = aws_instance.ec2_public_2.public_ip
# }
