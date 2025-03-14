variable "environment" {
  description = "The environment for the EC2 instance (e.g., dev, prod)"
  type        = string
}

variable "ec2_name" {
  description = "The base name for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
}

variable "public_subnet_id" {
  description = "The public subnet ID where the instance will be launched"
  type        = string
}

variable "ec2_sg_id" {
  description = "The security group object for the EC2 instance. It should have an 'id' attribute."
  type        = string
}

variable "assign_eip" {
  description = "Boolean flag to decide whether to assign an Elastic IP to the instance"
  type        = bool
  default     = false
}

variable "base64encoded_user_data" {
  description = "Optional base64-encoded user data for EC2 instance initialization. Leave empty to disable."
  type        = string
  default     = ""
}
