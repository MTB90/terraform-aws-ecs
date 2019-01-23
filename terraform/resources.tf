# VPC
module "vpc" {
  source = "./vpc"
  tags   = "${var.project_tags}"
  cidr   = "${var.network_address_space}"
}

# Subnets
module "public_subnets" {
  source = "./subnets"
  tags   = "${merge(var.project_tags, map("Name", "public"))}"

  vpc_id = "${module.vpc.vpc_id}"
  azs    = "${data.aws_availability_zones.available.names}"
  cidr   = "${var.network_address_space}"
  shift  = 0

  igw_id          = "${module.vpc.igw_id}"
  igw_association = true
}

module "app_subnets" {
  source = "./subnets"
  tags   = "${merge(var.project_tags, map("Name", "app"))}"

  vpc_id = "${module.vpc.vpc_id}"
  azs    = "${data.aws_availability_zones.available.names}"
  cidr   = "${var.network_address_space}"
  shift  = "${local.subnets}"
}

module "db_subnets" {
  source = "./subnets"
  tags   = "${merge(var.project_tags, map("Name", "db"))}"

  vpc_id = "${module.vpc.vpc_id}"
  azs    = "${data.aws_availability_zones.available.names}"
  cidr   = "${var.network_address_space}"
  shift  = "${2 * local.subnets}"
}

# ECS resource with launch configuration, auto scaling, service
module "ecs-cluster" {
  source = "./ecs-cluster"
  tags   = "${var.project_tags}"

  image_id      = "${var.ecs-cluster-ec2-image-id}"
  instance_type = "${var.ecs-cluster-ec2-instance-type}"
  vpc_id        = "${module.vpc.vpc_id}"
  subnets       = "${module.app_subnets.subnets}"
}
