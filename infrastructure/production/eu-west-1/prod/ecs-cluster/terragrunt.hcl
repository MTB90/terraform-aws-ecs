terraform {
  source = "../../../../terraform/ecs-cluster/"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  aws_region = "eu-west-1"

  aws_nat_ami                   = "ami-0236d0cbbbe64730c"
  aws_nat_instance_type         = "t2.micro"

  aws_ecs_cluster_ami           = "ami-0963349a5568210b8"
  aws_ecs_cluster_instance_type = "t2.micro"
  aws_ecs_ec2_key_pair_name     = "ecs-ec2"

  aws_ecs_ec2_min     = 2
  aws_ecs_ec2_max     = 6
  aws_ecs_ec2_desired = 2
}