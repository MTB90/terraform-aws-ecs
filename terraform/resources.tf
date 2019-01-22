data "aws_availability_zones" "available" {}

# VPC resource with all subnets
module "vpc" {
  source = "./vpc"
  tags   = "${var.project_tags}"

  cidr = "${var.network_address_space}"
  azs  = "${data.aws_availability_zones.available.names}"
}

# ECS resource with launch configuration, auto scaling, service
module "ecs-cluster-ec2" {
  source = "./ecs-cluster-ec2"
  tags   = "${var.project_tags}"
}
