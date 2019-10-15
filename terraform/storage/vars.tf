variable "domian_name" {
  description = "The domian name for app"
  type        = string
}

variable "aws_project_name" {
  description = "The project name for resource"
  type        = string
}

variable "aws_environment_type" {
  description = "The environment type for the resource"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  type        = string
}
