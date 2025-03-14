variable "key_pair_name" {
  description = "Name for the AWS key pair"
  type        = string
  default     = "my-key"
}

variable "public_key_path" {
  description = "Path to the local public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}


variable "nginx_lt_name_prefix" {
  description = "The name prefix for the NGINX Launch Template."
  type        = string
  default     = "nginx-lt"
}

variable "nginx_lt_instance_type" {
  description = "The instance type for the NGINX Launch Template."
  type        = string
  default     = "t2.micro"
}

variable "nginx_lt_instance_name" {
  description = "The name for the ASG instance in the NGINX Launch Template."
  type        = string
  default     = "nginx-lt-instance"
}

variable "nginx_lt_security_groups" {
  description = "The security groups to associate with the NGINX Launch Template."
  type        = list(string)
}

variable "nginx_lt_instance_profile_name" {
  description = "The name of the instance profile to associate with the NGINX Launch Template."
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to store the NGINX index.html file."
  type        = string
}

variable "asg_name" {
  description = "The name of the ASG."
  type        = string
  default     = "nginx-app-asg"
}

variable "asg_instance_name" {
  description = "The name of the ASG instance."
  type        = string
  default     = "nginx-app-asg-instance"
}

variable "asg_min_size" {
  description = "The minimum size of the ASG."
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "The maximum size of the ASG."
  type        = number
  default     = 4
}

variable "asg_desired_capacity" {
  description = "The desired capacity of the ASG."
  type        = number
  default     = 3
}

variable "asg_subnets" {
  description = "The subnets to associate with the ASG."
  type        = list(string)
}

variable "scale_out_adjustment" {
  description = "The number of instances to add to the ASG."
  type        = number
  default     = 1
}

variable "scale_in_adjustment" {
  description = "The number of instances to remove from the ASG."
  type        = number
  default     = -1

}

variable "cpu_high_threshold" {
  description = "The threshold for the CPU utilization metric."
  type        = number
  default     = 80
}


variable "cpu_low_threshold" {
  description = "The threshold for the CPU utilization metric."
  type        = number
  default     = 20
}


variable "target_group_arns" {
  description = "List of ALB target group ARNs to register with the ASG"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "The environment name (DEV, QA, PROD, etc.)"
  type        = string
}
