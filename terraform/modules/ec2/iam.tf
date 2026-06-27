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
resource "aws_iam_role_policy_attachment" "ecr_attach_ec2" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

## Allows an EC2 instance to be managed by AWS Systems Manager (SSM).
resource "aws_iam_role_policy_attachment" "ssm_attach_ec2" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


## Github identity provider resource
## GitHub Actions → OIDC Provider → IAM Role → Policies

resource "aws_iam_openid_connect_provider" "github_provider" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

## Github Actions role
resource "aws_iam_role" "github_actions_role" {
  name = "Github-Actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_provider.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:github.com/awilali:*"
          }
        }
      }
    ]
  })
}

## OIDC policy attachment
resource "aws_iam_role_policy_attachment" "ssm_github_ec2_attach" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.ssm_github_ec2_deploy_policy.arn
}

## OIDC created policy
resource "aws_iam_policy" "ssm_github_ec2_deploy_policy" {
  name = "ssm-github-ec2-deploy-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ssm:GetCommandInvocation",
          "ssm:ListCommandInvocations"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

## IAM OIDC POLICY to push to ecr
resource "aws_iam_role_policy_attachment" "ecr_full_access" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

## IAM OIDC POLICIES 
resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

## IAM OIDC - What is GitHub Actions allowed to do in AWS
resource "aws_iam_role_policy" "iam_terraform_access" {
  name = "iam-terraform-access"
  role = aws_iam_role.github_actions_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:AttachRolePolicy",
          "iam:PutRolePolicy",
          "iam:PassRole"
        ]
        Resource = "*"
      }
    ]
  })
}
