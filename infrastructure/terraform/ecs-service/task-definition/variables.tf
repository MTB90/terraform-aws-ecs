variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "region" {
  description = "A region to send container log data"
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

variable "auth_url" {
  description = "Auth base URL"
}

variable "auth_jwks_url" {
  description = "JWKS URL for well knows keys"
}

variable "auth_client_id" {
  description = "Auth client id"
}

variable "auth_client_secret" {
  description = "Auth client secret"
}

variable "url" {
  description = "URL for web"
}

variable "database" {
  description = "Database name"
}

variable "file_storage" {
  description = "File storage access"
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
