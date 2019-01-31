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

# EC2 variables
variable "ec2_launch_config_instance_type" {
  description = "EC2 instance type for ECS cluster launch configuration"
  default     = "t2.micro"
}

variable "ec2_launch_config_image_id" {
  description = "AMI image for EC2"
  default     = "ami-08a73ef2db6c656e5"
}

variable "ec2_autoscaling_limits" {
  type = "map"

  default = {
    min     = 2
    max     = 6
    desired = 2
  }
}

# ECS Cluster variables
variable "ecs_docker_image_uri" {
  description = "Docker image uri for task definition"
  default     = "752734372808.dkr.ecr.us-west-2.amazonaws.com/photorec:dev"
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

# Bastion instance variables
variable "bastion_image_id" {
  description = "AMI image for bastion instance"
  default     = "ami-032509850cf9ee54e"
}

variable "bastion_instance_type" {
  description = "NAT instance type"
  default     = "t2.micro"
}

variable "bastion_sq_inbound_rule" {
  description = "Bastion sq inbound rule for ssh"
}

variable "bastion_key_name" {
  description = "Key name for EC2 bastion key pair"
}
