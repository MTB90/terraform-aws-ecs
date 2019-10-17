resource "aws_s3_bucket" "s3_storage" {
  bucket = var.tags["Name"]
  acl    = "private"
  tags   = var.tags
}
