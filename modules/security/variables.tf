variable "ec2_role_name" {
  description = "The name of the IAM role for EC2"
  type        = string
  default     = "ec2-instance-role"
}

variable "s3_bucket_id" {
  description = "The name of the S3 bucket"
  type        = string
}
variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket to grant access"
  type        = string
}

variable "instance_profile_name" {
  description = "The name of the IAM instance profile"
  type        = string
  default     = "ec2-instance-profile"
}

variable "environment" {
  description = "The environment name (DEV, QA, PROD, etc.)"
  type        = string
}
