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

variable "aws_ecs_container_min" {
  description = "App autoscaling policy min ecs container"
}

variable "aws_ecs_container_max" {
  description = "App autoscaling policy max ecs container"
}

variable "aws_ecs_container_desired" {
  description = "App autoscaling policy desired ecs container"
}

variable "aws_ecs_container_memory" {
  description = "Memory for ecs container"
}

variable "aws_ecs_container_cpu_unit" {
  description = "CPU unit for ecs container"
}
