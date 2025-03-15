output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.nginx_alb.alb_dns_name
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = module.rds.rds_endpoint
}

output "bastion_public_ip" {
  description = "The public IP address of the bastion host"
  value       = module.bastion.ec2_instance_public_ip
}
output "jenkins_public_ip" {
  description = "The public IP address of the Jenkins server"
  value       = module.jenkins.ec2_instance_public_ip
}
