variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "cidr" {
  description = "The CIDR block for the VPC"
}
