output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.nginx_alb.alb_dns_name
}
