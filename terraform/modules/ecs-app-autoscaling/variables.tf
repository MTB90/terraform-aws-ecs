variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "cluster_name" {
  description = "ECS cluster name"
}

variable "service_name" {
  description = "ECS service name"
}

variable "capacity_limits" {
  description = "Capacity limits for app autoscaling"
  default     = {}
}
