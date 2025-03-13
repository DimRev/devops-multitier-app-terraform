variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "acl" {
  description = "The ACL for the bucket."
  type        = string
  default     = "private"
}

variable "versioning_enabled" {
  description = "Enable versioning on the bucket."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm to use. e.g., AES256"
  type        = string
  default     = "AES256"
}

variable "prevent_destroy" {
  description = "Prevent the bucket from being destroyed."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "block_public_acls" {
  description = "Whether to block public ACLs."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether to block public bucket policies."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether to ignore public ACLs."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether to restrict public bucket access."
  type        = bool
  default     = true
}
