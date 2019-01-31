# ECS resource with launch configuration, auto scaling
module "ecs_cluster" {
  source = "./modules/ecs-cluster"
  tags   = "${var.tags}"
  region = "${var.region}"
}

module "ecs_ec2_launch_configuration" {
  source = "./modules/launch-configuration"
  tags   = "${var.tags}"

  vpc_id          = "${aws_vpc.vpc.id}"
  image_id        = "${var.ecs_ec2_launch_config_image_id}"
  instance_type   = "${var.ecs_ec2_launch_config_instance_type}"
  user_data       = "${module.ecs_cluster.user_data}"
  sq_inbound_rule = "${module.alb.sg_id}"
  key_name        = "${var.bastion_key_name}"
}

module "ecs_ec2_autoscaling" {
  source = "./modules/autoscaling"
  tags   = "${var.tags}"

  subnets                 = "${module.app_subnets.subnets}"
  launch_configuration_id = "${module.ecs_ec2_launch_configuration.id}"
  capacity_limits         = "${var.ecs_ec2_autoscaling_group_capacity_limits}"
}

module "ecs_ec2_task_definition" {
  source = "./modules/ecs-task-definition"
  tags   = "${var.tags}"

  region           = "${var.region}"
  cpu_unit         = 128
  memory           = 128
  workdir          = "/app"
  docker_image_uri = "${var.ecs_docker_image_uri}"
}

module "ecs_ec2_service" {
  source = "./modules/ecs-service"
  tags   = "${var.tags}"

  alb_arn             = "${module.alb.arn}"
  tg_arn              = "${module.alb.tg_arn}"
  cluster_id          = "${module.ecs_cluster.id}"
  task_definition_arn = "${module.ecs_ec2_task_definition.arn}"
  container_name      = "${module.ecs_ec2_task_definition.container_name}"
}
