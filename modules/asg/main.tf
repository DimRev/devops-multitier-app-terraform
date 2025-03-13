resource "aws_autoscaling_group" "nginx_web_asg" {
  name                = var.asg_name
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
    value               = var.asg_instance_name
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
