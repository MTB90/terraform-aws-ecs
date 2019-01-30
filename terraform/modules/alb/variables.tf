variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "vpc_id" {
  description = "VPC id where elb will be deployed"
}

variable "subnets" {
  description = "List of subnet IDs to launch recources in"
  default     = []
}
