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

variable "aws_ecs_cluster_ami" {
  description = "AMI for ecs machine"
  type        = string
}

variable "aws_ecs_cluster_instance_type" {
  description = "Instance type for ecs machine (e.g. t2.micro)"
  type        = string
}

variable "aws_nat_ami" {
  description = "AMI for NAT machine"
  type        = string
}

variable "aws_nat_instance_type" {
  description = "Instance type for NAT machine (e.g. t2.micro)"
  type        = string
}

variable "aws_ecs_ec2_min" {
  description = "Autoscaling policy min ecs ec2 machines"
}

variable "aws_ecs_ec2_max" {
  description = "Autoscaling policy max ecs ec2 machines"
}

variable "aws_ecs_ec2_desired" {
  description = "Autoscaling policy desired ecs ec2 machines"
}

variable "aws_ecs_ec2_key_pair_name" {
  description = "Admin key pair name for ecs machines"
  type        = string
}

variable "tfstate_global_bucket" {
    type = string
}

variable "tfstate_global_bucket_region" {
    type = string
}