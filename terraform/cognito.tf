module "cognito_user_pool" {
  source = "./modules/cognito-user-pool"
  tags   = "${var.tags}"
}
