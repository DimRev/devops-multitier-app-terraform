resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = local.cpu_high_alarm_name
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

  tags = {
    Name = local.cpu_high_alarm_name
    Env  = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = local.cpu_low_alarm_name
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

  tags = {
    Name = local.cpu_low_alarm_name
    Env  = var.environment
  }
}
