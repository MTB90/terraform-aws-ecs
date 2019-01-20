variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID that subnet layer will be associate"
}

variable "azs" {
  description = "A list of Availability zones for subnet layer"
  default     = []
}

variable "cidr" {
  description = "The CIDR block for the subnet layer"
}

variable "shift" {
  description = "Shift for subnet ip address"
}

variable "igw" {
  description = "The internet gateway associate to the subnet layer"
  default     = 0
}

variable "public" {
  description = "If true then associate igw to the subnet layer"
  default = false
}