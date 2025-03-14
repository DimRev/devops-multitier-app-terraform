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
}

variable "db_root_password" {
  description = "Database root password"
  type        = string
}

variable "rds_security_group_ids" {
  description = "List of security group ids"
  type        = list(string)
}

variable "rds_name" {
  description = "The name of the RDS instance."
  type        = string
  default     = "rds-instance"
}


variable "subnet_ids" {
  description = "List of subnet ids"
  type        = list(string)
}

variable "environment" {
  description = "The environment name (DEV, QA, PROD, etc.)"
  type        = string
}
