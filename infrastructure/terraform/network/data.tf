data "aws_availability_zones" "available" {}

data "aws_acm_certificate" "acm_cert" {
  domain = var.domian_name
}

data "aws_ssm_parameter" "cert_record_type" {
  name = format("%s-cert-record-type", local.prefix)
}

data "aws_ssm_parameter" "cert_record_name" {
  name = format("%s-cert-record-name", local.prefix)
}

data "aws_ssm_parameter" "cert_record_value" {
  name = format("%s-cert-record-value", local.prefix)
}