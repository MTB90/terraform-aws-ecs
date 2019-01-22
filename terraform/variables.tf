variable "region" {
  default = "us-west-2"
}

variable "project_tags" {
  type = "map"

  default = {
    Project     = "photorec"
    Envarioment = "dev"
  }
}

# VPC variables
variable "network_address_space" {
  default = "10.0.0.0/16"
}
