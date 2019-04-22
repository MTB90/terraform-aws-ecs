# Local variables
locals {
  module = "cognito-user-pool"
  name   = "${format("%s-%s", var.tags["Project"], var.tags["Envarioment"])}"
  tags   = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

resource "aws_cognito_user_pool" "user_pool" {
  name = "${local.name}"
  tags = "${local.tags}"

  username_attributes = ["email"]

  schema {
    name                = "nickname"
    attribute_data_type = "String"
    required            = true
    mutable             = false
  }

  auto_verified_attributes = ["email"]

  verification_message_template = {
    default_email_option = "CONFIRM_WITH_LINK"
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name = "${format("%s-client",local.name)}"

  user_pool_id                 = "${aws_cognito_user_pool.user_pool.id}"
  supported_identity_providers = ["COGNITO"]
  generate_secret              = true

  allowed_oauth_scopes                 = ["openid"]
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true

  callback_urls = ["${format("https://%s/callback", var.domain)}"]
  logout_urls   = ["${format("https://%s/", var.domain)}"]
}

resource "aws_cognito_user_pool_domain" "user_pool_domian" {
  domain       = "${local.tags["Project"]}"
  user_pool_id = "${aws_cognito_user_pool.user_pool.id}"
}
