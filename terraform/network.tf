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
  source = "./modules/subnets"
  tags   = "${merge(var.tags, map("Name", "public"))}"

  vpc_id = "${aws_vpc.vpc.id}"
  azs    = "${data.aws_availability_zones.available.names}"
  cidr   = "${var.network_address_space}"
  shift  = 0
}

module "igw" {
  source = "./modules/igw"
  tags   = "${var.tags}"

  vpc_id         = "${aws_vpc.vpc.id}"
  route_table_id = "${module.public_subnets.route_table_id}"
}

# Create app subnets
module "app_subnets" {
  source = "./modules/subnets"
  tags   = "${merge(var.tags, map("Name", "app"))}"

  vpc_id = "${aws_vpc.vpc.id}"
  azs    = "${data.aws_availability_zones.available.names}"
  cidr   = "${var.network_address_space}"
  shift  = "${local.subnets}"
}

# Create db subnets
module "db_subnets" {
  source = "./modules/subnets"
  tags   = "${merge(var.tags, map("Name", "db"))}"

  vpc_id = "${aws_vpc.vpc.id}"
  azs    = "${data.aws_availability_zones.available.names}"
  cidr   = "${var.network_address_space}"
  shift  = "${2 * local.subnets}"
}

# NAT instance
module "nat_instance" {
  source = "./modules/nat-instance"
  tags   = "${var.tags}"

  vpc_id          = "${aws_vpc.vpc.id}"
  subnet_id       = "${module.public_subnets.subnets[0]}"
  image_id        = "${var.nat_image_id}"
  instance_type   = "${var.nat_instance_type}"
  sq_inbound_rule = "${module.ec2_launch_configuration.sg_id}"
  route_table_id  = "${module.app_subnets.route_table_id}"
}

# Bastion instance
module "bastion_instance" {
  source = "./modules/bastion"
  tags   = "${var.tags}"

  vpc_id          = "${aws_vpc.vpc.id}"
  subnet_id       = "${module.public_subnets.subnets[0]}"
  image_id        = "${var.bastion_image_id}"
  instance_type   = "${var.bastion_instance_type}"
  sq_inbound_rule = "${var.bastion_sq_inbound_rule}"
  key_name        = "${var.bastion_key_name}"
}

# ALB
module "alb" {
  source = "./modules/alb"
  tags   = "${var.tags}"

  vpc_id  = "${aws_vpc.vpc.id}"
  subnets = "${module.public_subnets.subnets}"
}
