output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "alb_sg_id" {
  value = module.alb.sg_id
}

output "app_subnets" {
  value = module.app_subnets.subnets
}

output "public_subnets" {
  value = module.public_subnets.subnets
}

output "app_route_table_id" {
  value = module.app_subnets.route_table_id
}