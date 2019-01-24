variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "vpc_id" {
  description = "VPC id where IGW will be connected"
}

variable "route_table_id" {
  description = "Route table id where IGW will be added"
}
