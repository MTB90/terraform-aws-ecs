variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "vpc_id" {
  description = "VPC id where nat instance will be deployed"
}

variable "subnet_id" {
  description = "Subnet id for nat instance"
}

variable "sq_inbound_rule" {
  description = "Source security group inbound rule"
}
