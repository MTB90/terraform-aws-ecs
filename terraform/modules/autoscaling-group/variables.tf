variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "subnets" {
  description = "List of subnet IDs to launch recources in"
  default     = []
}

variable "launch_configuration_id" {
  description = "Launch configration if for autoscaling group"
}

variable "capacity_limits" {
  description = "Capacity limits for autoscaling group"
  default     = {}
}
