resource "aws_instance" "ec2_public_1" {
  ami                    = "ami-0e5497a77ef21b5ac"
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_1_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_pair_name #ssh key will be removed
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name


  user_data = file("${path.module}/user-data.sh")

  tags = {
    Name        = "devops-ec2-public-1"
    Environment = var.environment
  }
}


# EC2 profile to access the ecr
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name
}


# EC2 Role
resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Role policy or permission for ec2 to access ecr
resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

#ssm policy
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ECR Resource
resource "aws_ecr_repository" "app" {
  name         = "my-app"
  force_delete = true


  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"
}

# ECR Life cycle policy
# This prevents ECR from filling up with old images.

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
