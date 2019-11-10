locals {
  perfix             = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags               = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
  aws_ecs_ec2_limits = map("min", var.aws_ecs_ec2_min, "max", var.aws_ecs_ec2_max, "desired", var.aws_ecs_ec2_desired)
}
