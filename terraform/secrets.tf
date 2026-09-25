resource "random_password" "jwt_secret" {
  length  = 64
  special = true
}

resource "aws_secretsmanager_secret" "jwt" {
  name        = "${var.project_name}/jwt"
  description = "JWT signing secret for the Project Hub backend."

  tags = {
    Name        = "${var.project_name}-jwt"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_secretsmanager_secret_version" "jwt" {
  secret_id = aws_secretsmanager_secret.jwt.id

  secret_string = jsonencode({
    JWT_SECRET_KEY = random_password.jwt_secret.result
  })
}
