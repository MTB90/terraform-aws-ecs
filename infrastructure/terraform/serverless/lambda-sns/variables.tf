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

variable "lambda_policy" {
  description = "Lambda policy"
}

variable "lambda_variables" {
  description = "Lambda variables"
}

variable "sns_arn" {
  description = "The SNS ARN for lambda"
}