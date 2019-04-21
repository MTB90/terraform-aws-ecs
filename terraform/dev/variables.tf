variable "region" {
  default = "us-west-2"
}

variable "tags" {
  type = "map"

  default = {
    Project     = "photorec"
    Envarioment = "dev"
  }
}

