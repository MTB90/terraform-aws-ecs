output "public_subnets" {
  value = "${aws_subnet.public.*.id}"
}

output "app_subnets" {
  value = "${aws_subnet.app.*.id}"
}

output "db_subnets" {
  value = "${aws_subnet.db.*.id}"
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}
