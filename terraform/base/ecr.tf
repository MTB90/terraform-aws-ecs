resource "aws_ecr_repository" "aws_ecr_repo" {
  name = format("%s-%s-ecr", var.aws_project_name, var.aws_environment_type)
  tags = merge(map("Module", "ecr", "Project", var.aws_project_name, "Environment", var.aws_environment_type))
}
