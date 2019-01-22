output "subnets_app" {
  value = "${module.subnet_app.subnets}"
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}