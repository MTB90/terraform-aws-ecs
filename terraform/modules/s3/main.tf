# Local variables
locals {
  module = "s3"
  name   = format("%s-%s", var.tags["Project"], var.tags["Envarioment"])
  tags   = merge(var.tags, map("Module", local.module, "Name", local.name))
}

resource "aws_s3_bucket" "s3_storage" {
  bucket = local.name
  acl    = "private"
  tags   = local.tags
}
