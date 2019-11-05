locals {
  perfix             = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags               = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
  aws_ecs_ec2_limits = map("min", var.aws_ecs_ec2_min, "max", var.aws_ecs_ec2_max, "desired", var.aws_ecs_ec2_desired)
}

data "aws_vpc" "vpc" {
  tags = {
    Name = format("%s-%s-vpc", var.aws_project_name, var.aws_environment_type)
  }
}

data "aws_subnet_ids" "public_subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = format("%s-%s-public-subnet", var.aws_project_name, var.aws_environment_type)
  }
}

data "aws_subnet_ids" "app_subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = format("%s-%s-app-subnet", var.aws_project_name, var.aws_environment_type)
  }
}

data "aws_route_table" "app_route_table" {
  tags = {
    Name = format("%s-%s-app-subnet", var.aws_project_name, var.aws_environment_type)
  }
}

data "aws_security_group" "alb_security_group" {
  tags = {
    Name = format("%s-%s-alb", var.aws_project_name, var.aws_environment_type)
  }
}

data "aws_s3_bucket" "file_storage" {
  bucket = format("%s-%s-s3", var.aws_project_name, var.aws_environment_type)
}

module "ecs_cluster" {
  source = "./cluster"
  tags   = merge(local.tags, map("Name", format("%s-ecs-cluster", local.perfix)))
  region = var.aws_region
}

# Bastion instance
module "bastion_instance" {
  source = "./bastion-instance"
  tags   = merge(local.tags, map("Name", format("%s-bastion", local.perfix)))

  vpc_id          = data.aws_vpc.vpc.id
  subnet_id       = tolist(data.aws_subnet_ids.public_subnet_ids.ids)[0]
  image_id        = var.aws_bastion_ami
  instance_type   = var.aws_bastion_instance_type
  sq_inbound_rule = var.aws_bastion_inbound_rule
  key_name        = var.aws_bastion_key_pair_name
}


module "launch_configuration" {
  source = "./launch-configuration"
  tags   = merge(local.tags, map("Name", format("%s-ec2-launch-conf", local.perfix)))

  vpc_id        = data.aws_vpc.vpc.id
  alb_sg_id     = data.aws_security_group.alb_security_group.id
  bastion_sg_id = module.bastion_instance.sg_id
  file_storage  = data.aws_s3_bucket.file_storage.bucket

  ami           = var.aws_ecs_cluster_ami
  instance_type = var.aws_ecs_cluster_instance_type
  user_data     = module.ecs_cluster.user_data

  key_name = var.aws_ecs_ec2_key_pair_name
}

module "ec2_autoscaling" {
  source = "./autoscaling"
  tags   = merge(local.tags, map("Name", format("%s-ec2-autoscaling", local.perfix)))

  subnets                 = tolist(data.aws_subnet_ids.app_subnet_ids.ids)
  capacity_limits         = local.aws_ecs_ec2_limits
  launch_configuration_id = module.launch_configuration.id
}

module "nat_instance" {
  source = "./nat-instance"
  tags   = merge(local.tags, map("Name", format("%s-nat-instance", local.perfix)))

  vpc_id          = data.aws_vpc.vpc.id
  subnet_id       = tolist(data.aws_subnet_ids.public_subnet_ids.ids)[0]
  image_id        = var.aws_nat_ami
  instance_type   = var.aws_nat_instance_type
  sq_inbound_rule = module.launch_configuration.sg_id
  route_table_id  = data.aws_route_table.app_route_table.id
}
