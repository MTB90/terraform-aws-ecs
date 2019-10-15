variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "domian_name" {
  description = "Domian name"
}

variable "alb_zone_id" {
  description = "The ID of alb zone record"
}

variable "alb_dns_name" {
  description = "The DNS name for alb"
}

variable "record_type" {
  description = "Record type"
  type        = string
}

variable "record_name" {
  description = "Record name"
  type        = string
}

variable "record_value" {
  description = "Record value"
  type        = string
}
