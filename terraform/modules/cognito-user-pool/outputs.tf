output "pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

output "client_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
}

output "client_secret" {
  value = aws_cognito_user_pool_client.user_pool_client.client_secret
}

output "domain" {
  value = format("%s.auth.%s.amazoncognito.com", aws_cognito_user_pool_domain.user_pool_domian.domain, var.region)
}
