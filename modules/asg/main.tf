data "aws_ami" "amazon_linux_2_free_tier" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "nginx_web_lt" {
  name_prefix   = "${var.nginx_lt_name_prefix}-"
  image_id      = data.aws_ami.amazon_linux_2_free_tier.id
  instance_type = var.nginx_lt_instance_type

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install nginx -y
systemctl enable nginx
systemctl start nginx
cat <<EOM > /usr/share/nginx/html/index.html
<html>
  <head>
    <title>Hello, World!</title>
  </head>
  <body>
    <h1>Hello, World!</h1>
    <p>This is a simple web server running on an EC2 instance.</p>
  </body>
</html>
EOM
EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.nginx_lt_instance_name
    }
  }
}

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

