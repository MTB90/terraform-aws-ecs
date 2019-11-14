# VPC
resource "aws_vpc" "vpc" {
  tags                 = merge(local.tags, map("Name", format("%s-vpc", local.prefix)))
  cidr_block           = var.aws_network_address_space
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Create public subnets
module "public_subnets" {
  source = "./subnets"
  tags   = merge(local.tags, map("Name", format("%s-public-subnet", local.prefix)))

  vpc_id = aws_vpc.vpc.id
  azs    = data.aws_availability_zones.available.names
  cidr   = var.aws_network_address_space
  shift  = 0
}

module "igw" {
  source = "./igw"
  tags   = merge(local.tags, map("Name", format("%s-igw", local.prefix)))

  vpc_id         = aws_vpc.vpc.id
  route_table_id = module.public_subnets.route_table_id
}

# Create app subnets
module "app_subnets" {
  source = "./subnets"
  tags   = merge(local.tags, map("Name", format("%s-app-subnet", local.prefix)))

  vpc_id = aws_vpc.vpc.id
  azs    = data.aws_availability_zones.available.names
  cidr   = var.aws_network_address_space
  shift  = local.subnets
}

# Application load balancer
module "alb" {
  source = "./alb"
  tags   = merge(local.tags, map("Name", format("%s-alb", local.prefix)))

  vpc_id          = aws_vpc.vpc.id
  subnets         = module.public_subnets.subnets
  certificate_arn = data.aws_acm_certificate.acm_cert.arn
}

# Hosted zones
module "hosted_zones" {
  source = "./hosted-zones"
  tags   = merge(local.tags, map("Name", format("%s-hosted-zones", local.prefix)))

  domian_name  = var.domian_name
  alb_zone_id  = module.alb.zone_id
  alb_dns_name = module.alb.dns_name

  record_type  = data.aws_ssm_parameter.cert_record_type.value
  record_name  = data.aws_ssm_parameter.cert_record_name.value
  record_value = data.aws_ssm_parameter.cert_record_value.value
}