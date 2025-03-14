output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "A list of public subnet IDs."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "A list of private subnet IDs."
  value       = aws_subnet.private[*].id
}

output "alb_sg_id" {
  description = "The ID of the ALB security group."
  value       = aws_security_group.alb_sg.id
}

output "ec2_sg_id" {
  description = "The ID of the EC2 security group."
  value       = aws_security_group.ec2_sg.id
}

output "rds_sg_id" {
  description = "The ID of the RDS security group."
  value       = aws_security_group.rds_sg.id
}

output "bastion_sg_id" {
  description = "The ID of the Bastion security group."
  value       = aws_security_group.bastion_sg.id
}

output "jenkins_sg_id" {
  description = "The ID of the Jenkins security group."
  value       = aws_security_group.jenkins_sg.id
}
