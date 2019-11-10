terraform {
  source = "../../../../terraform/ecs-services/"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  aws_region                = "eu-west-1"

  aws_ecs_container_min     = 2
  aws_ecs_container_max     = 6
  aws_ecs_container_desired = 3

  aws_ecs_container_cpu_unit = 128
  aws_ecs_container_memory   = 128
}