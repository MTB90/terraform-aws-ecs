# Dynamodb
module "dynamodb" {
  source = "../modules/dynamodb"
  tags   = "${var.tags}"
}

module "s3" {
  source = "../modules/s3"
  tags   = "${var.tags}"
}
