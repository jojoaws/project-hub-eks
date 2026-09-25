resource "aws_iam_role" "github_actions_terraform" {
  name        = "${var.project_name}-github-actions-terraform"
  description = "GitHub Actions Terraform CI role for the Project Hub infrastructure."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"

            "token.actions.githubusercontent.com:sub" = [
              "repo:jojoaws@278461269/project-hub-eks@1382609740:ref:refs/heads/main",
              "repo:jojoaws@278461269/project-hub-eks@1382609740:pull_request"
            ]
          }
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-github-actions-terraform"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_iam_policy" "github_actions_terraform_state" {
  name        = "${var.project_name}-github-actions-terraform-state"
  description = "Access to the Project Hub Terraform state."

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ListTerraformState"
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = "arn:aws:s3:::cloud-mastery-tfstate-bucket-005008919446"

        Condition = {
          StringLike = {
            "s3:prefix" = [
              "project-hub-eks/*"
            ]
          }
        }
      },

      {
        Sid    = "ManageTerraformState"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = [
          "arn:aws:s3:::cloud-mastery-tfstate-bucket-005008919446/project-hub-eks/terraform.tfstate",
          "arn:aws:s3:::cloud-mastery-tfstate-bucket-005008919446/project-hub-eks/terraform.tfstate.tflock"
        ]
      },

      {
        Sid    = "ReadProjectHubSecrets"
        Effect = "Allow"

        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue"
        ]

        Resource = [
          aws_secretsmanager_secret.jwt.arn,
          "${aws_db_instance.postgres.master_user_secret[0].secret_arn}*"
        ]
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-github-actions-terraform-state"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "github_actions_terraform_read_only" {
  role       = aws_iam_role.github_actions_terraform.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "github_actions_terraform_state" {
  role       = aws_iam_role.github_actions_terraform.name
  policy_arn = aws_iam_policy.github_actions_terraform_state.arn
}

resource "aws_iam_role" "github_actions_deploy" {
  name        = "${var.project_name}-github-actions-deploy"
  description = "GitHub Actions deployment role for the Project Hub application."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"

            "token.actions.githubusercontent.com:sub" = "repo:jojoaws@278461269/project-hub-eks@1382609740:ref:refs/heads/main"
          }
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-github-actions-deploy"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_iam_policy" "github_actions_deploy" {
  name        = "${var.project_name}-github-actions-deploy"
  description = "Least-privilege deployment permissions for Project Hub GitHub Actions."

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ECRAuthentication"
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },

      {
        Sid    = "ECRPush"
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeImages",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]

        Resource = aws_ecr_repository.backend.arn
      },

      {
        Sid    = "DescribeEKSCluster"
        Effect = "Allow"

        Action = [
          "eks:DescribeCluster"
        ]

        Resource = module.eks.cluster_arn
      },

      {
        Sid    = "UploadFrontend"
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = aws_s3_bucket.frontend.arn
      },

      {
        Sid    = "ManageFrontendObjects"
        Effect = "Allow"

        Action = [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:PutObject"
        ]

        Resource = "${aws_s3_bucket.frontend.arn}/*"
      },

      {
        Sid    = "InvalidateCloudFront"
        Effect = "Allow"

        Action = [
          "cloudfront:CreateInvalidation"
        ]

        Resource = aws_cloudfront_distribution.frontend.arn
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-github-actions-deploy"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "github_actions_deploy" {
  role       = aws_iam_role.github_actions_deploy.name
  policy_arn = aws_iam_policy.github_actions_deploy.arn
}

resource "aws_eks_access_entry" "github_actions_deploy" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.github_actions_deploy.arn
  type          = "STANDARD"

  kubernetes_groups = [
    "project-hub-deployer"
  ]
}

resource "aws_eks_access_policy_association" "github_actions_deploy" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.github_actions_deploy.arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"

  access_scope {
    type       = "namespace"
    namespaces = ["project-hub-eks-app"]
  }

  depends_on = [
    aws_eks_access_entry.github_actions_deploy
  ]
}
