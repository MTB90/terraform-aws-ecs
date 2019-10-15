# Resources
resource "aws_route53_zone" "route_53_zone" {
  name = var.domian_name
  tags = var.tags
}

resource "aws_route53_record" "alias_alb" {
  zone_id = aws_route53_zone.route_53_zone.zone_id
  name    = var.domian_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "route_53_record" {
  zone_id = aws_route53_zone.route_53_zone.zone_id
  name    = var.record_name
  type    = var.record_type
  records = [var.record_value]
  ttl     = "300"
}
