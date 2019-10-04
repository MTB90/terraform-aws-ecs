variable "region" {
  default = "eu-west-1"
}

variable "tags" {
  type = "map"

  default = {
    Project     = "photorec"
    Envarioment = "prod"
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
  default     = "ami-0d7db0e3ec32793ae"
}

variable "ec2_autoscaling_limits" {
  type = "map"

  default = {
    min     = 2
    max     = 6
    desired = 2
  }
}

variable "ecs_app_autoscaling_limits" {
  type = "map"

  default = {
    min     = 2
    max     = 6
    desired = 3
  }
}

# NAT-instance variables
variable "nat_image_id" {
  description = "AMI image for NAT instance"
  default     = "ami-0236d0cbbbe64730c"
}

variable "nat_instance_type" {
  description = "NAT instance type"
  default     = "t2.micro"
}

# ECS Cluster variables
variable "ecs_docker_image_uri" {
  description = "Docker image uri for task definition"
}

# Bastion instance variables
variable "bastion_image_id" {
  description = "AMI image for bastion instance"
  default     = "ami-0ce71448843cb18a1"
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

# Domain
variable "domain" {
  description = "Domain name"
}

# SSL cert
variable "certificate_arn" {
  description = "The ARN of the default SSL server certificate"
}

# CNAME records
variable "cname_records" {
  type = "list"

  default = [
    {
      name  = ""
      value = ""
    },
    {
      name  = ""
      value = ""
    },
  ]
}
