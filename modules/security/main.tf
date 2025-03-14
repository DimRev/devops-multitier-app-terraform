locals {
  ec2_role_name             = "${var.environment}-${var.ec2_role_name}-ec2-role-security"
  ec2_policy_name           = "${var.environment}-${var.ec2_role_name}-ec2-policy-security"
  ec2_instance_profile_name = "${var.environment}-${var.instance_profile_name}-ec2-instance_profile-security"
}

resource "aws_s3_bucket_policy" "alb_logs_policy" {
  bucket = var.s3_bucket_id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowALBLogging",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::127311923021:root"
        },
        Action   = "s3:PutObject",
        Resource = "${var.s3_bucket_arn}/logs/alb/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" : "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}



resource "aws_iam_role" "ec2_role" {
  name = local.ec2_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_policy" "ec2_policy" {
  name        = local.ec2_policy_name
  description = "Allows EC2 instances to read from S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:ListBucket"
      ]
      Resource = [
        var.s3_bucket_arn,
        "${var.s3_bucket_arn}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.ec2_role.name
}
