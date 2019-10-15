terraform {
  source = "../../../../../terraform/network/"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  aws_region                = "eu-west-1"
  aws_network_address_space = "10.0.0.0/16"

  aws_bastion_ami           =  "ami-0ce71448843cb18a1"
  aws_bastion_instance_type = "t2.micro"
}
