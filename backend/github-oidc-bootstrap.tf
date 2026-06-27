
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
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }

          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:awilali/aws-cicd-container-pipeline:ref:refs/heads/main",
              "repo:awilali/aws-cicd-container-pipeline:pull_request:refs/pull/*"
            ]
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

resource "aws_iam_role_policy_attachment" "ecr_push_attach" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_ecr_push.arn
}

resource "aws_iam_policy" "github_ecr_push" {
  name = "github-ecr-push-my-app"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource = "arn:aws:ecr:us-east-2:123456789012:repository/my-app"
      }
    ]
  })
}

##
resource "aws_iam_role_policy_attachment" "ec2_deploy_attach" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_ec2_deploy.arn
}

##
resource "aws_iam_policy" "github_ec2_deploy" {
  name = "github-ec2-deploy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeTags"
        ]
        Resource = "*"
      }
    ]
  })
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

## S3 bucket - policy below is attached to it
resource "aws_iam_role_policy_attachment" "tf_github_s3" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.terraform_state_s3.arn
}

## S3 bucket - custom policy
resource "aws_iam_policy" "terraform_state_s3" {
  name = "terraform-state-s3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::devops-project-s3bucket-eleanor"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::devops-project-s3bucket-eleanor/*"
      }
    ]
  })
}
