output "ec2_public_1_ip" {
  value = aws_instance.ec2_public_1.public_ip
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "instance_id" {
  value = aws_instance.ec2_public_1.id
}
