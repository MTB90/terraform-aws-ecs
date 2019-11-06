locals {
  prefix = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags   = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
  aws_ecs_container_limits = map(
    "min", var.aws_ecs_container_min,
    "max", var.aws_ecs_container_max,
    "desired", var.aws_ecs_container_desired
  )
}
