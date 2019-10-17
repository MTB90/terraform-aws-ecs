data "aws_availability_zones" "available" {}

locals {
  subnets  = length(data.aws_availability_zones.available.names)
  name = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
}

# VPC
resource "aws_vpc" "vpc" {
  tags                 = merge(local.tags, map("Name", format("%s-vpc", local.name)))
  cidr_block           = var.aws_network_address_space
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Create public subnets
module "public_subnets" {
  source = "./subnets"
  tags   = merge(local.tags, map("Name", format("%s-public-subnet", local.name)))

  vpc_id = aws_vpc.vpc.id
  azs    = data.aws_availability_zones.available.names
  cidr   = var.aws_network_address_space
  shift  = 0
}

module "igw" {
  source = "./igw"
  tags   = merge(local.tags, map("Name", format("%s-igw", local.name)))

  vpc_id         = aws_vpc.vpc.id
  route_table_id = module.public_subnets.route_table_id
}

# Create app subnets
module "app_subnets" {
  source = "./subnets"
  tags   = merge(local.tags, map("Name", format("%s-app-subnet", local.name)))

  vpc_id = aws_vpc.vpc.id
  azs    = data.aws_availability_zones.available.names
  cidr   = var.aws_network_address_space
  shift  = local.subnets
}

# Application load balancer
module "alb" {
  source = "./alb"
  tags   = merge(local.tags, map("Name", format("%s-alb", local.name)))

  vpc_id          = aws_vpc.vpc.id
  subnets         = module.public_subnets.subnets
  certificate_arn = data.terraform_remote_state.base.outputs.aws_cert_arn
}

# Hosted zones
module "hosted_zones" {
  source = "./hosted-zones"
  tags   = merge(local.tags, map("Name", format("%s-hosted-zones", local.name)))

  domian_name  = var.domian_name
  alb_zone_id  = module.alb.zone_id
  alb_dns_name = module.alb.dns_name

  record_type  = data.terraform_remote_state.base.outputs.aws_cert_domain_validation_options[0].resource_record_type
  record_name  = data.terraform_remote_state.base.outputs.aws_cert_domain_validation_options[0].resource_record_name
  record_value = data.terraform_remote_state.base.outputs.aws_cert_domain_validation_options[0].resource_record_value
}