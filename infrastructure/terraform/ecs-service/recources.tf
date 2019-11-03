locals {
  name  = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags  = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
  aws_ecs_container_limits = map(
    "min", var.aws_ecs_container_min,
    "max", var.aws_ecs_container_max,
    "desired", var.aws_ecs_container_desired
  )
}

module "ecs_ec2_task_definition" {
  source = "./task-definition"
  tags   =  merge(local.tags, map("Name", format("%s-ecs-task-definition", local.name)))

  region           = var.aws_region
  cpu_unit         = var.aws_ecs_container_cpu_unit
  memory           = var.aws_ecs_container_memory
  workdir          = "/app"
  docker_image_uri = format("%s:latest", data.terraform_remote_state.base.outputs.aws_ecr_arn)

  url                   = format("https://%s", var.domian_name)
  file_storage          = data.terraform_remote_state.storage.outputs.file_storage
  database              = data.terraform_remote_state.storage.outputs.database

  auth_url           = data.terraform_remote_state.cognito.outputs.auth_url
  auth_jwks_url      = data.terraform_remote_state.cognito.outputs.auth_jwks_url
  auth_client_id     = data.terraform_remote_state.cognito.outputs.auth_client_id
  auth_client_secret = data.terraform_remote_state.cognito.outputs.auth_client_secret
}

module "ecs_ec2_service" {
  source = "./service"
  tags   = merge(local.tags, map("Name", format("%s-ecs-service", local.name)))

  alb_arn             = data.terraform_remote_state.network.outputs.alb_arn
  tg_arn              = data.terraform_remote_state.network.outputs.alb_tg_arn
  cluster_id          = data.terraform_remote_state.ecs-cluster.outputs.cluster_id
  capacity_limits     = local.aws_ecs_container_limits
  task_definition_arn = module.ecs_ec2_task_definition.arn
  container_name      = module.ecs_ec2_task_definition.container_name
}

module "ecs_app_autoscaling" {
  source = "./app-autoscaling"
  tags   = merge(local.tags, map("Name", format("%s-ecs-app-autoscaling", local.name)))

  cluster_name    = data.terraform_remote_state.ecs-cluster.outputs.cluster_name
  service_name    = module.ecs_ec2_service.name
  capacity_limits = local.aws_ecs_container_limits
}
