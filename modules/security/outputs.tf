output "iam_role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.ec2_role.arn
}

output "iam_instance_profile" {
  description = "The name of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2_profile.name
}
