# Resources
resource "aws_service_discovery_private_dns_namespace" "private_dns_namespace" {
  name        = format("%s.%s.local", var.tags["Project"], var.tags["Environment"])
  description = "Private DNS namespace for service discovery"
  vpc         =  var.vpc_id
}

resource "aws_service_discovery_service" "service_discovery" {
  name = var.tags["Name"]

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.private_dns_namespace.id

    dns_records {
      ttl  = 10
      type = "SRV"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
