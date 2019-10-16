locals {
  name  = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags  = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
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

  cognito_domain        = data.terraform_remote_state.cognito.outputs.domain
  cognito_pool_id       = data.terraform_remote_state.cognito.outputs.pool_id
  cognito_client_id     = data.terraform_remote_state.cognito.outputs.client_id
  cognito_client_secret = data.terraform_remote_state.cognito.outputs.client_secret
}