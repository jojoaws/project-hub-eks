variable "aws_region" {
  description = "AWS region for the Project Hub infrastructure."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming and tagging."
  type        = string
  default     = "project-hub"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "prod"
}
