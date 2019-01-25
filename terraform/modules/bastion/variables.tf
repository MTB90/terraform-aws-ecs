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
  description = "AMI image for EC2 bastion instance"
}

variable "instance_type" {
  description = "Instance type for bastion instance"
}

variable "sq_inbound_rule" {
  description = "Source security group inbound rule"
}

variable "key_name" {
  description = "Key name for EC2 key pair"
}
