output "aws_lb_alb_pu" {
  value = aws_lb.alb_pu.dns_name
}
output "aws_lb_target" {
  value = aws_lb_target_group.tg-alb.arn
}
  





