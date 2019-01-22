variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "instance_type" {
  description = "Instance type for launch configration"
}

variable "image_id" {
  description = "AMI image for EC2 in launch configration"
}
