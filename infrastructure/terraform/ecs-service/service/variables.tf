variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "cluster_id" {
  description = "The arn of the ECS Cluster"
}

variable "task_definition_arn" {
  description = "ARN of the task definition that you want to run in your service."
}

variable "container_name" {
  description = "Container name from container definition"
}

variable "alb_arn" {
  description = "Arn for application load balancer"
}

variable "tg_arn" {
  description = "ARN for target group assigned to ecs service"
}

variable "capacity_limits" {
  description = "Capacity limits for app autoscaling"
  default     = {}
}
