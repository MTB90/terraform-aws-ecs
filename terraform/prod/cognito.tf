module "cognito_user_pool" {
  source = "../modules/cognito-user-pool"
  tags   = var.tags
  domain = var.domain
  region = var.region
}
