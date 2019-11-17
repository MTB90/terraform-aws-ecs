data "aws_vpc" "vpc" {
  tags = {
    Name = format("%s-%s-vpc", var.aws_project_name, var.aws_environment_type)
  }
}

data "aws_ecr_repository" "web_ecr" {
  name = format("%s-%s-web-ecr", var.aws_project_name, var.aws_environment_type)
}

data "aws_s3_bucket" "file_storage" {
  bucket = format("%s-%s-s3", var.aws_project_name, var.aws_environment_type)
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
