variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "vpc_id" {
  description = "VPC id where launch configuration will be deployed"
}

variable "instance_type" {
  description = "Instance type for launch configration"
}

variable "image_id" {
  description = "AMI image for EC2 in launch configration"
}

variable "user_data" {
  description = "User data for launch configration"
}

variable "sq_inbound_rule" {
  description = "Source security group inbound rule"
}
