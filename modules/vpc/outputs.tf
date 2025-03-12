output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet."
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet."
  value       = aws_subnet.private.id
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

