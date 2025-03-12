output "asg_name" {
  description = "The name of the ASG."
  value       = aws_autoscaling_group.nginx_web_asg.name
}

output "launch_template_id" {
  description = "The ID of the launch template."
  value       = aws_launch_template.nginx_web_lt.id
}
