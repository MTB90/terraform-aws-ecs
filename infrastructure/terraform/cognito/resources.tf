locals {
  prefix = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags   = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
}

resource "aws_cognito_user_pool" "user_pool" {
  name = format("%s-user-pool", local.prefix)
  tags = merge(local.tags, map("Name", format("%s-user-pool", local.prefix)))

  username_attributes = ["email"]

  schema {
    name                = "nickname"
    attribute_data_type = "String"
    required            = true
    mutable             = false

    string_attribute_constraints {
      min_length = 3
      max_length = 64
    }
  }

  auto_verified_attributes = ["email"]

  verification_message_template {
    default_email_option = "CONFIRM_WITH_LINK"
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name = format("%s-user-pool-client", local.prefix)

  user_pool_id                 = aws_cognito_user_pool.user_pool.id
  supported_identity_providers = ["COGNITO"]
  generate_secret              = true

  allowed_oauth_scopes                 = ["openid"]
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true

  callback_urls = [format("https://%s/callback", var.domain_name)]
  logout_urls   = [format("https://%s/", var.domain_name)]
}

resource "aws_cognito_user_pool_domain" "user_pool_domian" {
  domain       = var.aws_project_name
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_ssm_parameter" "auth_client_id" {
  name = format("%s-auth-client-id", local.prefix)
  tags = merge(local.tags, map("Name", format("%s-auth-client-id", local.prefix)))

  type  = "SecureString"
  value = aws_cognito_user_pool_client.user_pool_client.id
}

resource "aws_ssm_parameter" "auth_client_secret" {
  name = format("%s-auth-client-secret", local.prefix)
  tags = merge(local.tags, map("Name", format("%s-auth-client-secret", local.prefix)))

  type  = "SecureString"
  value = aws_cognito_user_pool_client.user_pool_client.client_secret
}

resource "aws_ssm_parameter" "auth_url" {
  name = format("%s-auth-url", local.prefix)
  tags = merge(local.tags, map("Name", format("%s-auth-url", local.prefix)))

  type  = "String"
  value = format("https://%s.auth.%s.amazoncognito.com", aws_cognito_user_pool_domain.user_pool_domian.domain, var.aws_region)
}

resource "aws_ssm_parameter" "auth_jwks_url" {
  name = format("%s-auth-jwks-url", local.prefix)
  tags = merge(local.tags, map("Name", format("%s-auth-jwks-url", local.prefix)))

  type  = "String"
  value = format("https://cognito-idp.%s.amazonaws.com/%s/.well-known/jwks.json", var.aws_region, aws_cognito_user_pool.user_pool.id)
}