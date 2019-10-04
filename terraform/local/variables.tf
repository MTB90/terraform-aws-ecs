variable "region" {
  default = "eu-west-1"
}

variable "tags" {
  type = "map"

  default = {
    Project     = "photorec"
    Envarioment = "local"
  }
}
