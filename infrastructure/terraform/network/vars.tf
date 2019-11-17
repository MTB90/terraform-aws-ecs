variable "domain_name" {
  description = "The domain name for app"
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

variable "aws_network_address_space" {
  description = "Network address space"
  type        = string
}

variable "tfstate_global_bucket" {
  type = string
}

variable "tfstate_global_bucket_region" {
  type = string
}