locals {
  alb_name            = "${var.environment}-${var.alb_name}-alb-alb"
  target_group_name   = "${var.environment}-${var.alb_name}-tg-alb"
  http_listener_name  = "${var.environment}-${var.alb_name}-http_listener-alb"
  https_listener_name = "${var.environment}-${var.alb_name}-https_listener-alb"
}

resource "aws_lb" "main" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_security_groups
  subnets            = var.alb_subnets

  access_logs {
    bucket  = var.alb_log_bucket
    enabled = true
    prefix  = "logs/alb"
  }
  tags = {
    Name = local.alb_name
    Env  = var.environment
  }
}

resource "aws_lb_target_group" "main" {
  name        = "${var.alb_name}-tg"
  port        = var.enable_https ? 443 : 80
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = 5
    interval            = 30
    path                = var.health_check_path
    matcher             = "200"
  }

  tags = {
    Name = local.target_group_name
    Env  = var.environment
  }
}

# HTTP Listener (conditionally created)
resource "aws_lb_listener" "http" {
  count             = var.enable_https ? 0 : 1
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  tags = {
    Name = local.http_listener_name
    Env  = var.environment
  }
}

# HTTPS Listener (conditionally created)
resource "aws_lb_listener" "https" {
  count             = var.enable_https ? 1 : 0
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  tags = {
    Name = local.https_listener_name
    Env  = var.environment
  }
}
