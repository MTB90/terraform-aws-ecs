variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "file_storage" {
  description = "File storage access"
}

variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  type        = string
}
