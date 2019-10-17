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

variable "image_id" {
  description = "AMI image for EC2 NAT instance"
}

variable "instance_type" {
  description = "Instance type for NAT instance"
}

variable "sq_inbound_rule" {
  description = "Source security group inbound rule"
}

variable "route_table_id" {
  description = "Route table id where nat instance should be point"
}
