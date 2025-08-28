resource "aws_secretsmanager_secret" "ghcr_login_secret" {
  name        = "${var.project_name}-${var.env}-ghcr-login-secret"
  description = "GitHub Container Registry dockerconfigjson"

  tags = {
    Name = "${var.project_name}-${var.env}-ghcr-login-secret"
  }
}

resource "aws_secretsmanager_secret_version" "ghcr_login_secret" {
  secret_id = aws_secretsmanager_secret.ghcr_login_secret.id
  secret_string = var.dockerconfigjson_data
}