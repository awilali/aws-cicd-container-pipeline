## EC2 requires a instance profile as it can't assume the IAM role directly. 
## Container that allows an IAM role to be attached to an EC2 instance.
## EC2 → Instance Profile → IAM Role → Policies

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
        Service = "ec2.amazonaws.com" #This is the service that assumes this role (and the permissions/policies that come with it)
      }
      Action = "sts:AssumeRole"
    }]
  })
}

## IAM Role policy Allows an EC2 instance to pull and read Docker images from Amazon ECR.
# resource "aws_iam_role_policy_attachment" "ecr_attach_ec2" {
#   role       = aws_iam_role.ec2_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
# }


resource "aws_iam_role_policy" "ecr_inline_policy" {
  name = "ec2-ecr-readonly-inline"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Authenticate with ECR
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },

      # Pull images from ECR
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}



## Allows an EC2 instance to be managed by AWS Systems Manager (SSM).
resource "aws_iam_role_policy_attachment" "ssm_attach_ec2" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

