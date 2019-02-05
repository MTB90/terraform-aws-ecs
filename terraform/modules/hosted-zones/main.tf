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

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.route_53_zone.zone_id}"
  name    = "${var.domian}"
  type    = "A"

  alias {
    name                   = "${var.alb_dns_name}"
    zone_id                = "${var.alb_zone_id}"
    evaluate_target_health = true
  }
}
