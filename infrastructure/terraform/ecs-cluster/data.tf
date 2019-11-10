data "aws_vpc" "vpc" {
  tags = {
    Name = format("%s-%s-vpc", var.aws_project_name, var.aws_environment_type)
  }
}

data "aws_subnet_ids" "public_subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = format("%s-%s-public-subnet", var.aws_project_name, var.aws_environment_type)
  }
}

data "aws_subnet_ids" "app_subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = format("%s-%s-app-subnet", var.aws_project_name, var.aws_environment_type)
  }
}

data "aws_route_table" "app_route_table" {
  tags = {
    Name = format("%s-%s-app-subnet", var.aws_project_name, var.aws_environment_type)
  }
}

data "aws_security_group" "alb_security_group" {
  tags = {
    Name = format("%s-%s-alb", var.aws_project_name, var.aws_environment_type)
  }
}

data "aws_s3_bucket" "file_storage" {
  bucket = format("%s-%s-s3", var.aws_project_name, var.aws_environment_type)
}
