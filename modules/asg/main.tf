locals {
  asg_name              = "${var.environment}-${var.asg_name}-asg-asg"
  cpu_high_alarm_name   = "${var.environment}-${var.asg_name}-cpu-high-alarm-asg"
  cpu_low_alarm_name    = "${var.environment}-${var.asg_name}-cpu-low-alarm-asg"
  scale_out_policy_name = "${var.environment}-${var.asg_name}-scale-out-policy-asg"
  scale_in_policy_name  = "${var.environment}-${var.asg_name}-scale-in-policy-asg"
  nginx_lt_name         = "${var.environment}-${var.nginx_lt_instance_name}-nginx-lt-asg"
}

resource "aws_autoscaling_group" "nginx_web_asg" {
  name                = local.asg_name
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  desired_capacity    = var.asg_desired_capacity
  vpc_zone_identifier = var.asg_subnets
  launch_template {
    id      = aws_launch_template.nginx_web_lt.id
    version = "$Latest"
  }

  target_group_arns = var.target_group_arns

  tag {
    key                 = "Name"
    value               = local.asg_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Env"
    value               = var.environment
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
