# Local variables
locals {
  module = "route-hosted-zone"
  name   = "${format("%s-%s", var.tags["Project"] ,local.module)}"
  tags   = "${merge(var.tags, map("Module", local.module))}"
}

# Resources
resource "aws_route53_zone" "route_53_zone" {
  name = "${var.domian}"
  tags = "${local.tags}"
}

resource "aws_route53_record" "domain" {
  zone_id = "${aws_route53_zone.route_53_zone.zone_id}"
  name    = "${var.domian}"
  type    = "A"

  alias {
    name                   = "${var.alb_dns_name}"
    zone_id                = "${var.alb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www_domain" {
  zone_id = "${aws_route53_zone.route_53_zone.zone_id}"
  name    = "${format("www.%s", var.domian)}"
  type    = "A"

  alias {
    name                   = "${aws_route53_record.domain.name}"
    zone_id                = "${aws_route53_record.domain.zone_id}"
    evaluate_target_health = true
  }
}
