# Local variables
locals {
  module = "route-hosted-zone"
  name   = "${format("%s-%s", var.tags["Project"], var.tags["Envarioment"])}"
  tags   = "${merge(var.tags, map("Module", local.module))}"
}

# Resources
resource "aws_route53_zone" "route_53_zone" {
  name = "${var.domian}"
  tags = "${local.tags}"
}

resource "aws_route53_record" "alias_alb" {
  zone_id = "${aws_route53_zone.route_53_zone.zone_id}"
  name    = "${var.domian}"
  type    = "A"

  alias {
    name                   = "${var.alb_dns_name}"
    zone_id                = "${var.alb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cname_record" {
  zone_id = "${aws_route53_zone.route_53_zone.zone_id}"
  name    = "${lookup(var.cname_records[count.index], "name")}"
  type    = "CNAME"
  ttl     = "300"

  count   = "${length(var.cname_records)}"
  records = ["${lookup(var.cname_records[count.index], "value")}"]
}
