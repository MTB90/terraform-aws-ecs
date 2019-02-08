variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "domian" {
  description = "Domian name"
}

variable "alb_zone_id" {
  description = "The ID of alb zone record"
}

variable "alb_dns_name" {
  description = "The DNS name for alb"
}

variable "cname_records" {
  description = "CNAME records for hosted zones"
  default     = []
  type        = "list"
}
