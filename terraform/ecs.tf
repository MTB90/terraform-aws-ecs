# ECS resource with launch configuration, auto scaling
module "ecs_cluster" {
  source = "./modules/ecs-cluster"
  tags   = "${var.tags}"
}

module "ecs_ec2_launch_configuration" {
  source = "./modules/launch-configuration"
  tags   = "${var.tags}"

  vpc_id          = "${aws_vpc.vpc.id}"
  image_id        = "${var.ecs_ec2_launch_config_image_id}"
  instance_type   = "${var.ecs_ec2_launch_config_instance_type}"
  user_data       = "${module.ecs_cluster.user_data}"
  sq_inbound_rule = "${module.bastion_instance.sg_id}"
}

module "ecs_ec2_autoscaling_group" {
  source = "./modules/autoscaling-group"
  tags   = "${var.tags}"

  subnets                 = "${module.app_subnets.subnets}"
  launch_configuration_id = "${module.ecs_ec2_launch_configuration.id}"
  capacity_limits         = "${var.ecs_ec2_autoscaling_group_capacity_limits}"
}

module "ecs_ec2_task_definition" {
  source = "./modules/ecs-task-definition"
  tags   = "${var.tags}"

  cpu_unit         = 128
  memory           = 128
  workdir          = "/app"
  docker_image_uri = "${var.ecs_docker_image_uri}"
}

module "ecs_ec2_service" {
  source = "./modules/ecs-service"
  tags   = "${var.tags}"

  vpc_id              = "${aws_vpc.vpc.id}"
  subnets             = "${module.app_subnets.subnets}"
  cluster_id          = "${module.ecs_cluster.id}"
  task_definition_arn = "${module.ecs_ec2_task_definition.arn}"
}
