variable "jenkins_name" {
  description = "The name of the Jenkins server"
  type        = string
  default     = "jenkins"
}

variable "jenkins_sg_name" {
  description = "The name of the Jenkins security group"
  type        = string
  default     = "jenkins_sg"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "The CIDR blocks allowed to access the bastion host"
  type        = list(string)
}

variable "key_name" {
  description = "The name of the SSH key pair to use for the bastion host"
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet"
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}
