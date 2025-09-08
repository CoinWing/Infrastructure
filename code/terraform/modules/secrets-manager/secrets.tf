# GitHub Container Registry 시크릿
resource "aws_secretsmanager_secret" "github_registry" {
  name        = "${var.project_name}-${var.env}-github-registry"
  description = "GitHub Container Registry credentials for Cowing project"
  
  tags = {
    Name = "${var.project_name}-${var.env}-github-registry"
  }
}

resource "aws_secretsmanager_secret_version" "github_registry" {
  secret_id = aws_secretsmanager_secret.github_registry.id
  secret_string = jsonencode({
    server   = "ghcr.io"
    username = var.github_username
    password = var.github_password
    email    = var.github_email
  })
}

# JWT 시크릿 추가
resource "aws_secretsmanager_secret" "jwt_secret" {
  name        = "${var.project_name}-${var.env}-jwt-secret"
  description = "JWT secret for Cowing project authentication"
  
  tags = {
    Name = "${var.project_name}-${var.env}-jwt-secret"
  }
}

resource "aws_secretsmanager_secret_version" "jwt_secret" {
  secret_id = aws_secretsmanager_secret.jwt_secret.id
  secret_string = jsonencode({
    jwt_secret = var.jwt_secret
  })
}

# MariaDB 시크릿 추가
resource "aws_secretsmanager_secret" "mariadb_secret" {
  name        = "${var.project_name}-${var.env}-mariadb-secret"
  description = "MariaDB credentials for Cowing project"
  
  tags = {
    Name = "${var.project_name}-${var.env}-mariadb-secret"
  }
}

resource "aws_secretsmanager_secret_version" "mariadb_secret" {
  secret_id = aws_secretsmanager_secret.mariadb_secret.id
  secret_string = jsonencode({
    username = var.mariadb_username
    password = var.mariadb_password
  })
}

# Redis 시크릿 추가
resource "aws_secretsmanager_secret" "redis_secret" {
  name        = "${var.project_name}-${var.env}-redis-secret"
  description = "Redis credentials for Cowing project"
  
  tags = {
    Name = "${var.project_name}-${var.env}-redis-secret"
  }
}

resource "aws_secretsmanager_secret_version" "redis_secret" {
  secret_id = aws_secretsmanager_secret.redis_secret.id
  secret_string = jsonencode({
    password = var.redis_password
  })
}

# SQS 시크릿 추가
resource "aws_secretsmanager_secret" "sqs_config_secret" {
  name        = "${var.project_name}-${var.env}-sqs-config-secret"
  description = "SQS config for Cowing project"
  
  tags = {
    Name = "${var.project_name}-${var.env}-sqs-config-secret"
  }
}

resource "aws_secretsmanager_secret_version" "sqs_config_secret" {
  secret_id = aws_secretsmanager_secret.sqs_config_secret.id
  secret_string = jsonencode({
    queue_name = var.queue_name
    pd_redis_password = var.pd_redis_password
    access_key = var.access_key
    secret_key = var.secret_key
    sqs_uri = var.sqs_uri
  })
}