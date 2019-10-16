locals {
  name = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
}


module "ecs_cluster" {
  source = "./cluster"
  tags   = merge(local.tags, map("Name", format("%s-ecs-cluster", local.name)))
  region = var.aws_region
}
