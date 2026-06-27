
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
              "repo:awilali/aws-cicd-container-pipeline:pull_request"
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
