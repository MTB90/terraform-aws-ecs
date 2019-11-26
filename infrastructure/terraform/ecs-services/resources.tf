module "ecs_web_task_definition" {
  source = "./task-definition"
  tags   = merge(local.tags, map("Name", format("%s-web-ecs-task-def", local.prefix)))

  cpu_unit         = var.aws_ecs_container_cpu_unit
  memory           = var.aws_ecs_container_memory
  workdir          = "/app"
  docker_image_uri = format("%s:latest", data.aws_ecr_repository.web_ecr.repository_url)

  container_definition_file = "${path.root}/task-container/web.tpl"

  environments = map(
    "region", var.aws_region,
    "project", var.aws_project_name,
    "service", "web",
    "environment", var.aws_environment_type
  )
}

module "ecs_web_service" {
  source = "./ec2-service"
  tags   = merge(local.tags, map("Name", format("%s-web-ecs-service", local.prefix)))

  tg_arn                = data.aws_alb_target_group.app_alb_tg.arn
  cluster_id            = data.aws_ecs_cluster.ecs_cluster.arn
  capacity_limits       = local.aws_ecs_container_limits
  task_definition_arn   = module.ecs_web_task_definition.arn
  container_name        = module.ecs_web_task_definition.container_name
}

module "ecs_web_app_autoscaling" {
  source = "./app-autoscaling"
  tags   = merge(local.tags, map("Name", format("%s-ecs-app-autoscaling", local.prefix)))

  cluster_name    = data.aws_ecs_cluster.ecs_cluster.cluster_name
  service_name    = module.ecs_web_service.name
  capacity_limits = local.aws_ecs_container_limits
}

