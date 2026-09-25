resource "aws_iam_policy" "backend" {
  name        = "${var.project_name}-backend"
  description = "Least-privilege AWS permissions for the Project Hub backend workload."

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      {
        Sid    = "ListProjectHubBucket"
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = aws_s3_bucket.app.arn
      },

      {
        Sid    = "ManageProjectHubObjects"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = "${aws_s3_bucket.app.arn}/*"
      },

      {
        Sid    = "PublishProjectHubNotifications"
        Effect = "Allow"

        Action = [
          "sns:Publish"
        ]

        Resource = aws_sns_topic.app.arn
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-backend"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_iam_role" "backend" {
  name        = "${var.project_name}-backend"
  description = "IAM role for the Project Hub backend workload."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-backend"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "backend" {
  role       = aws_iam_role.backend.name
  policy_arn = aws_iam_policy.backend.arn
}

resource "aws_eks_pod_identity_association" "backend" {
  cluster_name    = module.eks.cluster_name
  namespace       = "project-hub-eks-app"
  service_account = "project-hub-eks-backend"
  role_arn        = aws_iam_role.backend.arn
}

resource "aws_iam_policy" "external_secrets" {
  name        = "${var.project_name}-external-secrets"
  description = "Least-privilege Secrets Manager read access for External Secrets Operator."

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
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
    Name        = "${var.project_name}-external-secrets"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_iam_role" "external_secrets" {
  name        = "${var.project_name}-external-secrets"
  description = "IAM role for External Secrets Operator."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-external-secrets"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "external_secrets" {
  role       = aws_iam_role.external_secrets.name
  policy_arn = aws_iam_policy.external_secrets.arn
}

resource "aws_eks_pod_identity_association" "external_secrets" {
  cluster_name    = module.eks.cluster_name
  namespace       = "external-secrets"
  service_account = "external-secrets"
  role_arn        = aws_iam_role.external_secrets.arn
}

resource "aws_iam_policy" "load_balancer_controller" {
  name        = "${var.project_name}-load-balancer-controller"
  description = "IAM policy for the AWS Load Balancer Controller."

  policy = file("${path.module}/aws-load-balancer-controller-policy.json")

  tags = {
    Name        = "${var.project_name}-load-balancer-controller"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_iam_role" "load_balancer_controller" {
  name        = "${var.project_name}-load-balancer-controller"
  description = "IAM role for the AWS Load Balancer Controller."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-load-balancer-controller"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "load_balancer_controller" {
  role       = aws_iam_role.load_balancer_controller.name
  policy_arn = aws_iam_policy.load_balancer_controller.arn
}

resource "aws_eks_pod_identity_association" "load_balancer_controller" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.load_balancer_controller.arn
}
