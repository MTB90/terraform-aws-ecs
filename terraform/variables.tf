variable "region" {
  default = "eu-west-1"
}

variable "project_tags" {
  type = "map"

  default = {
    Name        = "photorec"
    Project     = "Social-PhotoRec"
    Envarioment = "dev"
  }
}

# VPC variables
variable "network_address_space" {
  default = "10.0.0.0/16"
}
