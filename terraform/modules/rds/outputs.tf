output "rds_endpoint" {
  description = "RDS endpoint for database connection"
  value       = aws_db_instance.postgres.endpoint
}

output "rds_address" {
  description = "RDS address (hostname without port)"
  value       = aws_db_instance.postgres.address
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.postgres.port
}

output "rds_db_name" {
  description = "RDS database name"
  value       = aws_db_instance.postgres.db_name
}


output "rds_password" {
  description = "RDS password (sensitive)"
  value       = var.db_password
  sensitive   = true
}

output "db_password" {
  value       = var.db_password
  description = "The database password"
  sensitive   = true
}