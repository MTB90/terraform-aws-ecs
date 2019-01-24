data "aws_availability_zones" "available" {}

locals {
  subnets  = "${length(data.aws_availability_zones.available.names)}"
  vpc_name = "${format("%s-vpc", var.tags["Project"])}"
}

# VPC
resource "aws_vpc" "vpc" {
  tags                 = "${merge(var.tags, map("Module", "vpc", "Name", local.vpc_name))}"
  cidr_block           = "${var.network_address_space}"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Create public subnets
module "public_subnets" {
  source = "./subnets"
  tags   = "${merge(var.tags, map("Name", "public"))}"

  vpc_id = "${aws_vpc.vpc.id}"
  azs    = "${data.aws_availability_zones.available.names}"
  cidr   = "${var.network_address_space}"
  shift  = 0
}

module "igw" {
  source = "./igw"
  tags   = "${var.tags}"

  vpc_id         = "${aws_vpc.vpc.id}"
  route_table_id = "${module.app_subnets.route_table_id}"
}

# Create app subnets
module "app_subnets" {
  source = "./subnets"
  tags   = "${merge(var.tags, map("Name", "app"))}"

  vpc_id = "${aws_vpc.vpc.id}"
  azs    = "${data.aws_availability_zones.available.names}"
  cidr   = "${var.network_address_space}"
  shift  = "${local.subnets}"
}

# Create db subnets
module "db_subnets" {
  source = "./subnets"
  tags   = "${merge(var.tags, map("Name", "db"))}"

  vpc_id = "${aws_vpc.vpc.id}"
  azs    = "${data.aws_availability_zones.available.names}"
  cidr   = "${var.network_address_space}"
  shift  = "${2 * local.subnets}"
}

# ECS resource with launch configuration, auto scaling, service
module "ecs-cluster" {
  source = "./ecs-cluster"
  tags   = "${var.tags}"

  image_id      = "${var.ecs-cluster-ec2-image-id}"
  instance_type = "${var.ecs-cluster-ec2-instance-type}"
  vpc_id        = "${aws_vpc.vpc.id}"
  subnets       = "${module.app_subnets.subnets}"
}
