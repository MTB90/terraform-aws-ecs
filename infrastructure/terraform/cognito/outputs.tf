output "auth_url" {
  value = format("https://%s.auth.%s.amazoncognito.com", aws_cognito_user_pool_domain.user_pool_domian.domain, var.aws_region)
}

output "auth_jwks_url" {
  value = format("https://cognito-idp.%s.amazonaws.com/%s/.well-known/jwks.json", var.aws_region, aws_cognito_user_pool.user_pool.id)
}

output "auth_client_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
}

output "auth_client_secret" {
  value = aws_cognito_user_pool_client.user_pool_client.client_secret
}
