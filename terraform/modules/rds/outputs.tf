output "db_endpoint" {
  value = aws_db_instance.postgres.address
}

output "db_name" {
  value = aws_db_instance.postgres.db_name
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}
