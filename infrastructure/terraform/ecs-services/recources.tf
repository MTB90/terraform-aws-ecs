locals {
  prefix = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags   = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
  aws_ecs_container_limits = map(
    "min", var.aws_ecs_container_min,
    "max", var.aws_ecs_container_max,
    "desired", var.aws_ecs_container_desired
  )
}

data "aws_ecr_repository" "web_ecr" {
  name = format("%s-%s-web-ecr", var.aws_project_name, var.aws_environment_type)
}

data "aws_s3_bucket" "file_storage" {
  bucket = format("%s-%s-s3", var.aws_project_name, var.aws_environment_type)
}

data "aws_alb" "app_alb" {
  tags = {
    Name = format("%s-%s-alb", var.aws_project_name, var.aws_environment_type)
  }
}

data "aws_alb_target_group" "app_alb_tg" {
  name = format("%s-%s-alb-tg", var.aws_project_name, var.aws_environment_type)
}

data "aws_ecs_cluster" "ecs_cluster" {
  cluster_name = format("%s-%s-ecs-cluster", var.aws_project_name, var.aws_environment_type)
}

data "aws_ssm_parameter" "auth_url" {
  name = format("%s-%s-auth-url", var.aws_project_name, var.aws_environment_type)
}

data "aws_ssm_parameter" "auth_jwks_url" {
  name = format("%s-%s-auth-jwks-url", var.aws_project_name, var.aws_environment_type)
}

data "aws_ssm_parameter" "auth_client_id" {
  name = format("%s-%s-auth-client-id", var.aws_project_name, var.aws_environment_type)
}

data "aws_ssm_parameter" "auth_client_secret" {
  name = format("%s-%s-auth-client-secret", var.aws_project_name, var.aws_environment_type)
}

module "ecs_ec2_task_definition" {
  source = "./task-definition"
  tags   = merge(local.tags, map("Name", format("%s-ecs-task-definition", local.prefix)))

  region           = var.aws_region
  cpu_unit         = var.aws_ecs_container_cpu_unit
  memory           = var.aws_ecs_container_memory
  workdir          = "/app"
  docker_image_uri = format("%s:latest", data.aws_ecr_repository.web_ecr.arn)

  url          = format("https://%s", var.domian_name)
  file_storage = data.aws_s3_bucket.file_storage.bucket
  database     = format("%s-%s-dynamodb", var.aws_project_name, var.aws_environment_type)

  auth_url           = data.aws_ssm_parameter.auth_url.value
  auth_jwks_url      = data.aws_ssm_parameter.auth_jwks_url.value
  auth_client_id     = data.aws_ssm_parameter.auth_client_id.value
  auth_client_secret = data.aws_ssm_parameter.auth_client_secret.value
}

module "ecs_ec2_service" {
  source = "./service"
  tags   = merge(local.tags, map("Name", format("%s-web-ecs-service", local.prefix)))

  alb_arn             = data.aws_alb.app_alb.arn
  tg_arn              = data.aws_alb_target_group.app_alb_tg.arn
  cluster_id          = data.aws_ecs_cluster.ecs_cluster.arn
  capacity_limits     = local.aws_ecs_container_limits
  task_definition_arn = module.ecs_ec2_task_definition.arn
  container_name      = module.ecs_ec2_task_definition.container_name
}

module "ecs_app_autoscaling" {
  source = "./app-autoscaling"
  tags   = merge(local.tags, map("Name", format("%s-ecs-app-autoscaling", local.prefix)))

  cluster_name    = data.aws_ecs_cluster.ecs_cluster.cluster_name
  service_name    = module.ecs_ec2_service.name
  capacity_limits = local.aws_ecs_container_limits
}
