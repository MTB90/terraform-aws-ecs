locals {
  name = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
}

resource "aws_cognito_user_pool" "user_pool" {
  name = format("%s-user-pool", local.name)
  tags = merge(local.tags, map("Name", format("%s-user-pool", local.name)))

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
  name = format("%s-user-pool-client", local.name)

  user_pool_id                 = aws_cognito_user_pool.user_pool.id
  supported_identity_providers = ["COGNITO"]
  generate_secret              = true

  allowed_oauth_scopes                 = ["openid"]
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true

  callback_urls = [format("https://%s/callback", var.domian_name)]
  logout_urls   = [format("https://%s/", var.domian_name)]
}

resource "aws_cognito_user_pool_domain" "user_pool_domian" {
  domain       = var.aws_project_name
  user_pool_id = aws_cognito_user_pool.user_pool.id
}
