output "target_group_arn" {
  value = aws_lb_target_group.webserver-tg.arn
}

output "loadbalancer_dns_name" {
  value = aws_lb.webserver-alb.dns_name
}

output "webserver_alb_sg_id" {
  value = aws_security_group.webserver-alb-sg.id
}
