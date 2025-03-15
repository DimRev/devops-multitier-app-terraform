output "ec2_instance_id" {
  description = "The ID of the bastion host instance"
  value       = aws_instance.ec2_instance.id
}

output "ec2_instance_public_ip" {
  description = "The public IP address of the bastion host"
  value       = aws_instance.ec2_instance.public_ip
}
