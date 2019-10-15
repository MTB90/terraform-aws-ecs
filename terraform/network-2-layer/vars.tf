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

variable "aws_network_address_space" {
  description = "Network address space"
  type        = string
}

variable "aws_bastion_ami" {
  description = "AMI for bastion machine"
  type        = string
}

variable "aws_bastion_instance_type" {
  description = "Instance type for bastion machine (e.g. t2.micro)"
  type        = string
}

variable "aws_admin_inbound_rule" {
  description = "Admin indbound for bastion machine"
  type        = string
}

variable "aws_admin_key_pair_name" {
  description = "Admin key pair name for bastion machine"
  type        = string
}

variable "tfstate_global_bucket" {
    type = string
}

variable "tfstate_global_bucket_region" {
    type = string
}