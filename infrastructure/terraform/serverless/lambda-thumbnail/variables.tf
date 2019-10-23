variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "lambda_handler" {
  description = "Handeler for lambda"
  type        = string
}

variable "lambda_source" {
  description = "Source for lambda"
  type        = string
}

variable "file_storage" {
  description = "File storage access"
}