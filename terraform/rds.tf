data "aws_rds_engine_version" "postgres" {
  engine  = "postgres"
  version = "17"
  latest  = true
}

resource "aws_db_subnet_group" "postgres" {
  name        = "${var.project_name}-postgres"
  description = "Private subnet group for Project Hub PostgreSQL"
  subnet_ids  = module.vpc.private_subnets

  tags = {
    Name        = "${var.project_name}-postgres"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "${var.project_name}-postgres"

  engine = "postgres"

  engine_version = data.aws_rds_engine_version.postgres.version

  instance_class = "db.t4g.micro"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"

  db_name  = "projecthubdb"
  username = "dbadmin"

  manage_master_user_password = true

  db_subnet_group_name = aws_db_subnet_group.postgres.name

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  publicly_accessible = false

  storage_encrypted = true

  multi_az = false

  backup_retention_period = 1

  maintenance_window = "sun:03:00-sun:04:00"
  backup_window      = "02:00-03:00"

  skip_final_snapshot = true

  tags = {
    Name        = "${var.project_name}-postgres"
    Environment = var.environment
    Project     = var.project_name
  }
}
