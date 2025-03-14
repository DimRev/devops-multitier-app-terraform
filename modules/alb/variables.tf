# ALB

variable "alb_name" {
  description = "The name of the ALB."
  type        = string
  default     = "multitier-app-alb"
}

variable "alb_log_bucket" {
  description = "The name of the S3 bucket to store ALB logs."
  type        = string
}

variable "alb_security_groups" {
  description = "The security groups to associate with the ALB."
  type        = list(string)
}

variable "alb_subnets" {
  description = "The subnets to associate with the ALB."
  type        = list(string)
}

# TARGET GROUP


variable "target_group_protocol" {
  description = "The protocol to use for the target group."
  type        = string
  default     = "HTTP"
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "healthy_threshold" {
  description = "The healthy threshold for the target group."
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "The unhealthy threshold for the target group."
  type        = number
  default     = 2
}

variable "health_check_path" {
  description = "The health check path for the target group."
  type        = string
  default     = "/"
}

variable "enable_https" {
  description = "Whether to enable the HTTPS listener"
  type        = bool
  default     = false
}

variable "certificate_arn" {
  description = "Certificate ARN for the HTTPS listener (required if enable_https is true)"
  type        = string
  default     = ""
}
