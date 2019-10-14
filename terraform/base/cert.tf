resource "aws_acm_certificate" "aws_cert" {
  domain_name       = var.domian_name
  validation_method = "DNS"

  tags = merge(map("Module", "acm-ert", "Project", var.aws_project_name, "Environment", var.aws_environment_type))

  lifecycle {
    create_before_destroy = true
  }
}
