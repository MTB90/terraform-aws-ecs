variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "domain" {
  description = "Domain name"
}

variable "region" {
  description = "A region to send log data"
}