variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}


variable "cpu_unit" {
  description = "The number of cpu units to reserve for the container"
}

variable "memory" {
  description = "The memory for the container"
}

variable "docker_image_uri" {
  description = "Docker image uri for task definition"
}

variable "workdir" {
  description = "Working directory for container"
}

variable "environments" {
  description = "Environments variable for task definition"
  default     = {}
}

variable "container_definition_file" {
  description = "Container definition file"
}

variable "timeout" {
  description = "The time period in seconds to wait for health check to success"
  default     = 15
}

variable "interval" {
  description = "The time period in seconds between each health check execution"
  default     = 120
}

variable "start_period" {
  description = "The time to bootstrap app in seconds before health check"
  default     = 30
}

variable "retries" {
  description = "The number of times to retry a failed health check"
  default     = 3
}

