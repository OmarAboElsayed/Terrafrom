resource "aws_lb" "alb_pu" {
  name            = var.alb_name
  internal        = var.alb_type
  load_balancer_type = "application"
  security_groups = var.security_group
  subnets         = var.sub_alb_id
}

resource "aws_lb_target_group" "tg-alb" {
  name     = var.tg-alb_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_tg_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb_pu.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg-alb.arn
    type             = "forward"
  }
}
