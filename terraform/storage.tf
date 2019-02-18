# Dynamodb
module "dynamodb" {
  source = "./modules/dynamodb"
  tags   = "${var.tags}"
}