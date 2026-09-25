output "vpc_id" {
  description = "ID of the Project Hub VPC."
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "IDs of the private subnets."
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "IDs of the public subnets."
  value       = module.vpc.public_subnets
}

output "s3_bucket_name" {
  description = "Name of the Project Hub application S3 bucket."
  value       = aws_s3_bucket.app.id
}

output "s3_bucket_arn" {
  description = "ARN of the Project Hub application S3 bucket."
  value       = aws_s3_bucket.app.arn
}

output "rds_endpoint" {
  description = "Endpoint of the Project Hub PostgreSQL RDS instance."
  value       = aws_db_instance.postgres.address
}

output "rds_port" {
  description = "Port of the Project Hub PostgreSQL RDS instance."
  value       = aws_db_instance.postgres.port
}

output "rds_database_name" {
  description = "Database name of the Project Hub PostgreSQL instance."
  value       = aws_db_instance.postgres.db_name
}

output "rds_master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret managed by RDS for the PostgreSQL master credentials."
  value       = aws_db_instance.postgres.master_user_secret[0].secret_arn
}

output "sns_topic_arn" {
  description = "ARN of the Project Hub application SNS topic."
  value       = aws_sns_topic.app.arn
}

output "frontend_bucket_name" {
  description = "Name of the Project Hub frontend S3 bucket."
  value       = aws_s3_bucket.frontend.id
}

output "frontend_bucket_arn" {
  description = "ARN of the Project Hub frontend S3 bucket."
  value       = aws_s3_bucket.frontend.arn
}

output "ecr_backend_repository_url" {
  description = "ECR repository URL for the Project Hub backend."
  value       = aws_ecr_repository.backend.repository_url
}

output "ecr_backend_repository_arn" {
  description = "ARN of the Project Hub backend ECR repository."
  value       = aws_ecr_repository.backend.arn
}

output "cloudfront_distribution_id" {
  description = "ID of the Project Hub CloudFront distribution."
  value       = aws_cloudfront_distribution.frontend.id
}

output "cloudfront_domain_name" {
  description = "Public CloudFront domain name for the Project Hub application."
  value       = aws_cloudfront_distribution.frontend.domain_name
}
