variable "region" {
  default = "us-west-2"
}

variable "tags" {
  type = "map"

  default = {
    Project     = "photorec"
    Envarioment = "dev"
  }
}

# VPC variables
variable "network_address_space" {
  description = "VPC network address space"
  default     = "10.0.0.0/16"
}

# ECS Cluster variables
variable "ecs-cluster-ec2-instance-type" {
  description = "EC2 instance type for ECS cluster launch configuration"
  default     = "t2.micro"
}

variable "ecs-cluster-ec2-image-id" {
  description = "AMI image for EC2"
  default     = "ami-0b2cc421c0d3015b4"
}

# NAT-instance variables
variable "nat_image_id" {
  description = "AMI image for NAT instance"
  default     = "ami-40d1f038"
}

variable "nat_instance_type" {
  description = "NAT instance type"
  default     = "t2.micro"
}
