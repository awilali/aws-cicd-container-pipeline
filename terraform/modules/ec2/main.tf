resource "aws_instance" "ec2_public_1" {
  ami                    = "ami-0e5497a77ef21b5ac"
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_1_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_pair_name

  tags = {
    Name        = "devops-ec2-public-1"
    Environment = var.environment
  }
}

# resource "aws_instance" "ec2_public_2" {
#   ami                    = "ami-0c02fb55956c7d316"
#   instance_type          = "t2.micro"
#   subnet_id              = var.public_subnet_2_id
#   vpc_security_group_ids = [var.security_group_id]
#   key_name               = var.key_pair_name

#   tags = {
#     Name        = "devops-ec2-public-2"
#     Environment = var.environment
#   }
# }
