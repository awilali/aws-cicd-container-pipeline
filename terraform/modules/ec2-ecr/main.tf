#EC2
resource "aws_instance" "ec2_public_1" { #ec2_public_1
  ami                    = "ami-0e5497a77ef21b5ac"
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_1_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name


  user_data = file("${path.module}/user-data.sh")

  tags = {
    Name        = "docker-ec2-server" #devops-ec2-public-1
    Environment = var.environment
  }
}

## ECR Resource
resource "aws_ecr_repository" "app" {
  name         = "my-app"
  force_delete = true


  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"
}

## ECR Life cycle policy - This prevents ECR from filling up with old images.
resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"

        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }

        action = {
          type = "expire"
        }
      }
    ]
  })
}
