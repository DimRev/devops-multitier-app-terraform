variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
  default     = "multitier-app-vpc"
}

variable "public_subnet_obj_list" {
  description = "A list of maps holding the public subnet variables."
  type = list(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))
  default = [{
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    name              = "public-1"
  }]
}

variable "private_subnet_obj_list" {
  description = "A list of maps holding the private subnet variables."
  type = list(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))
  default = [{
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1a"
    name              = "private-1"
  }]
}

variable "bastion_allowed_ssh_cidrs" {
  description = "List of allowed CIDR blocks for SSH ingress"
  type        = list(string)
  default     = ["YOUR_PUBLIC_IP/32"] # Replace YOUR_PUBLIC_IP with your actual public IP (e.g., "203.0.113.4/32")
}

variable "environment" {
  description = "The environment name (DEV, QA, PROD, etc.)"
  type        = string
}
