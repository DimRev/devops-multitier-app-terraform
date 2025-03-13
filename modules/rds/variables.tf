variable "db_engine" {
  type        = string
  description = "Database engine type"
  default     = "mysql"
}

variable "db_engine_version" {
  type        = string
  description = "Database engine version"
  default     = "5.7"
}

variable "db_root_username" {
  type        = string
  description = "Database root username"
}

variable "db_root_password" {
  type        = string
  description = "Database root password"
}

variable "rds_security_group_ids" {
  type        = list(string)
  description = "List of security group ids"
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids"
}
