terraform {
  source = "../../../../terraform/serverless/"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  aws_region   = "eu-west-1"
}
