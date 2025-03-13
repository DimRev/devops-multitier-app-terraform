output "asg_name" {
  description = "The name of the ASG."
  value       = aws_autoscaling_group.nginx_web_asg.name
}

output "launch_template_id" {
  description = "The ID of the launch template."
  value       = aws_launch_template.nginx_web_lt.id
}

output "key_pair_name" {
  description = "The name of the key pair."
  value       = aws_key_pair.my_key.key_name
}
