locals {
  prefix = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags   = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
}

resource "aws_acm_certificate" "aws_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = merge(local.tags, map("Name", format("%s-aws-cert", local.prefix)))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecr_repository" "aws_ecr_web_repo" {
  name = format("%s-web-ecr", local.prefix)
  tags = merge(local.tags, map("Name", format("%s-web-ecr", local.prefix)))
}

resource "aws_ecr_repository" "aws_ecr_rest_repo" {
  name = format("%s-api-ecr", local.prefix)
  tags = merge(local.tags, map("Name", format("%s-api-ecr", local.prefix)))
}

resource "aws_ssm_parameter" "cert_record_type" {
  name = format("%s-cert-record-type", local.prefix)
  tags = merge(local.tags, map("Name", format("%s-cert-record-type", local.prefix)))

  type  = "String"
  value = aws_acm_certificate.aws_cert.domain_validation_options[0].resource_record_type
}

# SSM Parameters
resource "aws_ssm_parameter" "cert_record_name" {
  name = format("%s-cert-record-name", local.prefix)
  tags = merge(local.tags, map("Name", format("%s-cert-record-name", local.prefix)))

  type  = "SecureString"
  value = aws_acm_certificate.aws_cert.domain_validation_options[0].resource_record_name
}

resource "aws_ssm_parameter" "cert_record_value" {
  name = format("%s-cert-record-value", local.prefix)
  tags = merge(local.tags, map("Name", format("%s-cert-record-value", local.prefix)))

  type  = "SecureString"
  value = aws_acm_certificate.aws_cert.domain_validation_options[0].resource_record_value
}

resource "random_string" "random_web_secret_key" {
  length = 16
  special = true
}

resource "aws_ssm_parameter" "web_secret_key" {
  name = format("%s-web-secret-key", local.prefix)
  tags = merge(local.tags, map("Name", format("%s-web-secret-key", local.prefix)))

  type  = "SecureString"
  value = random_string.random_web_secret_key.result
}

resource "aws_ssm_parameter" "web_url" {
  name = format("%s-web-url", local.prefix)
  tags = merge(local.tags, map("Name", format("%s-web-url", local.prefix)))

  type  = "String"
  value = "https://${var.domain_name}"
}
