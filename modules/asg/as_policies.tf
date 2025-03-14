
resource "aws_autoscaling_policy" "scaling_out" {
  name                   = "${var.asg_name}-scaling-out"
  scaling_adjustment     = var.scale_out_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.nginx_web_asg.name
}


resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.asg_name}-cpu-low"
  scaling_adjustment     = var.scale_in_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.nginx_web_asg.name
}

