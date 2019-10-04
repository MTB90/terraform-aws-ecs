output "arn" {
  value = aws_alb.alb.arn
}

output "sg_id" {
  value = aws_security_group.alb_sg.id
}

output "tg_arn" {
  value = aws_alb_target_group.alb_tg.arn
}

output "dns_name" {
  value = aws_alb.alb.dns_name
}

output "zone_id" {
  value = aws_alb.alb.zone_id
}
