# Local variables
locals {
  module = "cognito-user-pool"
  name   = "${format("%s-%s", var.tags["Project"] ,local.module)}"
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

  verification_message_template = {
    default_email_option = "CONFIRM_WITH_LINK"
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name = "${format("%s-client",local.name)}"

  user_pool_id    = "${aws_cognito_user_pool.user_pool.id}"
  generate_secret = true
}
