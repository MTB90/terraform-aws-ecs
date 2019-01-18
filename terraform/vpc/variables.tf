variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "azs" {
  description = "A list of Availability zones in the region"
  default     = []
}

variable "cidr" {
  description = "The CIDR block for the VPC"
}
