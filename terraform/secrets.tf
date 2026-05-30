resource "aws_secretsmanager_secret" "umami_db" {
  name                    = "umami/database-url"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "umami_db" {
  secret_id = aws_secretsmanager_secret.umami_db.id
  secret_string = jsonencode({
    DATABASE_URL = "postgresql://umami:${var.db_password}@${module.rds.rds_address}:${module.rds.rds_port}/${module.rds.rds_db_name}?sslmode=require"
  })
}

resource "aws_secretsmanager_secret" "umami_app" {
  name                    = "umami/app-secrets"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "umami_app" {
  secret_id = aws_secretsmanager_secret.umami_app.id
  secret_string = jsonencode({
    APP_SECRET = var.app_secret
    HASH_SALT  = var.hash_salt
  })
}