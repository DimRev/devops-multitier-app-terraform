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


variable "s3_bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
  default     = "multitier-app-s3-bucket"
}

variable "s3_bucket_tags" {
  description = "A map of tags to assign to the bucket."
  type        = map(string)
  default = {
    Environment = "Dev"
    Project     = "multitier-app"
  }
}
