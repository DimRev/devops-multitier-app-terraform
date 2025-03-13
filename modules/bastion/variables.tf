variable "module_name" {
  description = "Module name prefix"
  type        = string
  default     = "bastion"
}

variable "vpc_id" {
  description = "The VPC ID where the bastion host will be launched"
  type        = string
}

variable "public_subnet_id" {
  description = "The public subnet ID for launching the bastion host"
  type        = string
}

variable "key_name" {
  description = "The AWS Key Pair name to use for SSH access"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "List of allowed CIDR blocks for SSH ingress"
  type        = list(string)
  default     = ["YOUR_PUBLIC_IP/32"] # Replace YOUR_PUBLIC_IP with your actual public IP (e.g., "203.0.113.4/32")
}
