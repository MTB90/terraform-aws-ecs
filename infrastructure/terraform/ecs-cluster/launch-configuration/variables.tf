variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "region" {
  description = "A region to send log data"
}

variable "vpc_id" {
  description = "VPC id where launch configuration will be deployed"
}

variable "instance_type" {
  description = "Instance type for launch configration"
}

variable "ami" {
  description = "AMI image for EC2 in launch configration"
}

variable "user_data" {
  description = "User data for launch configration"
}

variable "alb_sg_id" {
  description = "ALB security group id"
}

variable "bastion_sg_id" {
  description = "Bastion security group id"
}

variable "file_storage" {
  description = "File storage access"
}

variable "key_name" {
  description = "Key name for EC2 key pair"
}
