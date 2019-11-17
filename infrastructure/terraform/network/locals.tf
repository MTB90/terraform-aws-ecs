locals {
  subnets = length(data.aws_availability_zones.available.names)
  prefix  = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags    = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
}
