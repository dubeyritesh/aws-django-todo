resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier              = var.db_identifier
  engine                  = "postgres"
  engine_version          = "15.7"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  max_allocated_storage   = 100
  username                = var.db_user
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [var.db_sg_id]
  publicly_accessible     = false
  skip_final_snapshot     = true
  deletion_protection     = false
  multi_az                = true
  backup_retention_period = 7       # retain backups for 7 days
  backup_window           = "03:00-06:00"  # preferred backup time window
  auto_minor_version_upgrade = true

  tags = {
    Name = var.db_identifier
  }
}
