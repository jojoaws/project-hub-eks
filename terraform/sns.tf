resource "aws_sns_topic" "app" {
  name = "${var.project_name}-app"

  tags = {
    Name        = "${var.project_name}-app"
    Environment = var.environment
    Project     = var.project_name
  }
}
