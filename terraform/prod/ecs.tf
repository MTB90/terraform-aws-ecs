# ECS resource with launch configuration, auto scaling
module "ecs_cluster" {
  source = "../modules/ecs-cluster"
  tags   = "${var.tags}"
  region = "${var.region}"
}

module "ec2_launch_configuration" {
  source = "../modules/ec2-launch-configuration"
  tags   = "${var.tags}"

  vpc_id          = "${aws_vpc.vpc.id}"
  image_id        = "${var.ec2_launch_config_image_id}"
  instance_type   = "${var.ec2_launch_config_instance_type}"
  user_data       = "${module.ecs_cluster.user_data}"
  sq_inbound_rule = "${module.alb.sg_id}"
  key_name        = "${var.bastion_key_name}"
  storage         = "${module.s3.storage}"
}

module "ec2_autoscaling" {
  source = "../modules/ec2-autoscaling"
  tags   = "${var.tags}"

  subnets                 = "${module.app_subnets.subnets}"
  capacity_limits         = "${var.ec2_autoscaling_limits}"
  launch_configuration_id = "${module.ec2_launch_configuration.id}"
}

module "ecs_ec2_task_definition" {
  source = "../modules/ecs-task-definition"
  tags   = "${var.tags}"

  region           = "${var.region}"
  cpu_unit         = 128
  memory           = 128
  workdir          = "/app"
  docker_image_uri = "${var.ecs_docker_image_uri}"

  base_url              = "${format("https://%s",var.domain)}"
  storage               = "${module.s3.storage}"
  database              = "${module.dynamodb.database}"
  cognito_domain        = "${module.cognito_user_pool.domain}"
  cognito_pool_id       = "${module.cognito_user_pool.pool_id}"
  cognito_client_id     = "${module.cognito_user_pool.client_id}"
  cognito_client_secret = "${module.cognito_user_pool.client_secret}"
}

module "ecs_ec2_service" {
  source = "../modules/ecs-service"
  tags   = "${var.tags}"

  alb_arn             = "${module.alb.arn}"
  tg_arn              = "${module.alb.tg_arn}"
  cluster_id          = "${module.ecs_cluster.id}"
  capacity_limits     = "${var.ecs_app_autoscaling_limits}"
  task_definition_arn = "${module.ecs_ec2_task_definition.arn}"
  container_name      = "${module.ecs_ec2_task_definition.container_name}"
}

module "ecs_app_autoscaling" {
  source = "../modules/ecs-app-autoscaling"
  tags   = "${var.tags}"

  cluster_name    = "${module.ecs_cluster.name}"
  service_name    = "${module.ecs_ec2_service.name}"
  capacity_limits = "${var.ecs_app_autoscaling_limits}"
}
