variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
  default     = "multitier_app_vpc"
}

variable "public_subnet_obj_list" {
  description = "A list of maps holding the public subnet variables."
  type = list(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))
  default = [
    {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
      name              = "public-1"
    },
    {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
      name              = "public-2"
    }
  ]
}

variable "private_subnet_obj_list" {
  description = "A list of maps holding the private subnet variables."
  type = list(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))
  default = [
    {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1a"
      name              = "private-1"
    },
    {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-1b"
      name              = "private-2"
    }
  ]
}

variable "asg_name" {
  description = "The name of the ASG."
  type        = string
  default     = "nginx_asg"
}

variable "asg_instance_name" {
  description = "The name of the ASG instance."
  type        = string
  default     = "nginx_asg_instance"
}

variable "nginx_lt_name_prefix" {
  description = "The name prefix for the NGINX Launch Template."
  type        = string
  default     = "nginx_lt"
}

variable "nginx_lt_instance_name" {
  description = "The name for the ASG instance in the NGINX Launch Template."
  type        = string
  default     = "nginx_lt_instance"
}

variable "rds_name" {
  description = "The name of the RDS instance."
  type        = string
  default     = "rds_instance"
}

variable "db_engine" {
  description = "Database engine type"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "5.7"
}

variable "db_root_username" {
  description = "Database root username"
  type        = string
  default     = "root"
}

variable "db_root_password" {
  description = "Database root password"
  type        = string
  default     = "password"
}


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

variable "ec2_role_name" {
  description = "The name of the IAM role for EC2"
  type        = string
  default     = "ec2_role"
}

variable "ec2_instance_profile_name" {
  description = "The name of the EC2 instance profile"
  type        = string
  default     = "ec2_instance_profile"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
  default     = "multitier-app-s3-bucket"
}


variable "environment" {
  description = "The environment name (DEV, QA, PROD, etc.)"
  type        = string
  default     = "dev"
}

variable "bastion_name" {
  description = "The name of the bastion host."
  type        = string
  default     = "bastion"
}
