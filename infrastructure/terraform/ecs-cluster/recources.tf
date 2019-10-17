locals {
  name               = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags               = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
  aws_ecs_ec2_limits = map("min", var.aws_ecs_ec2_min, "max", var.aws_ecs_ec2_max, "desired", var.aws_ecs_ec2_desired)
}


module "ecs_cluster" {
  source = "./cluster"
  tags   = merge(local.tags, map("Name", format("%s-ecs-cluster", local.name)))
  region = var.aws_region
}

module "launch_configuration" {
  source = "./launch-configuration"
  tags   = merge(local.tags, map("Name", format("%s-ec2-launch-conf", local.name)))

  vpc_id          = data.terraform_remote_state.network.outputs.vpc_id
  sq_inbound_rule = data.terraform_remote_state.network.outputs.alb_sg_id
  file_storage    = data.terraform_remote_state.storage.outputs.file_storage

  ami             = var.aws_ecs_cluster_ami
  instance_type   = var.aws_ecs_cluster_instance_type
  user_data       = module.ecs_cluster.user_data

  key_name        = var.aws_ecs_ec2_key_pair_name
}

module "ec2_autoscaling" {
  source = "./autoscaling"
  tags   = merge(local.tags, map("Name", format("%s-ec2-autoscaling", local.name)))

  subnets                 = data.terraform_remote_state.network.outputs.app_subnets
  capacity_limits         = local.aws_ecs_ec2_limits
  launch_configuration_id = module.launch_configuration.id
}

module "nat_instance" {
  source = "./nat-instance"
  tags   = merge(local.tags, map("Name", format("%s-nat-instance", local.name)))

  vpc_id          = data.terraform_remote_state.network.outputs.vpc_id
  subnet_id       = data.terraform_remote_state.network.outputs.public_subnets[0]
  image_id        = var.aws_nat_ami
  instance_type   = var.aws_nat_instance_type
  sq_inbound_rule = module.launch_configuration.sg_id
  route_table_id  = data.terraform_remote_state.network.outputs.app_route_table_id
}