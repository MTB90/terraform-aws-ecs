output "aws_ecr_arn" {
  value = aws_ecr_repository.aws_ecr_repo.arn
}

output "aws_cert_arn" {
  value = aws_acm_certificate.aws_cert.arn
}

output "aws_cert_domain_validation_options" {
  value = aws_acm_certificate.aws_cert.domain_validation_options
}