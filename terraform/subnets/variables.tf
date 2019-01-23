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

variable "igw_id" {
  description = "(Optional) Internet gateway ID for subnets"
  default     = -1
}

variable "igw_association" {
  description = "(Optional) If true then igw should be added to subnet layer"
  default     = false
}

variable "nat_id" {
  description = "(Optional) NAT ID for subnets"
  default     = -1
}

variable "nat_association" {
  description = "(Optional) If true then nat should be added to subnet layer"
  default     = false
}
