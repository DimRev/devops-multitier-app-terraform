
resource "aws_autoscaling_policy" "scaling_out" {
  name                   = "${var.asg_name}-scaling-out"
  scaling_adjustment     = var.scale_out_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.nginx_web_asg.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.asg_name}-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = var.cpu_high_threshold

  alarm_actions = [aws_autoscaling_policy.scaling_out.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.nginx_web_asg.name
  }
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.asg_name}-cpu-low"
  scaling_adjustment     = var.scale_in_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.nginx_web_asg.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.asg_name}-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = var.cpu_low_threshold

  alarm_actions = [aws_autoscaling_policy.scale_in.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.nginx_web_asg.name
  }

}
