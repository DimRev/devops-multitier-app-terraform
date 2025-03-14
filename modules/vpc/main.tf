locals {
  vpc_name                 = "${var.environment}-${var.vpc_name}-vpc-vpc"
  igw_name                 = "${var.environment}-${var.vpc_name}-igw-vpc"
  nat_name                 = "${var.environment}-${var.vpc_name}-nat-vpc"
  nat_eip_name             = "${var.environment}-${var.vpc_name}-nat_eip-vpc"
  ec2_sg_name              = "${var.environment}-${var.vpc_name}-ec2_sg-vpc"
  alb_sg_name              = "${var.environment}-${var.vpc_name}-alb_sg-vpc"
  rds_sg_name              = "${var.environment}-${var.vpc_name}-rds-sg-vpc"
  private_subnet_name      = "${var.environment}-${var.vpc_name}-private_subnet-vpc"
  private_route_table_name = "${var.environment}-${var.vpc_name}-private_rt-vpc"
  public_subnet_name       = "${var.environment}-${var.vpc_name}-public_subnet-vpc"
  public_route_table_name  = "${var.environment}-${var.vpc_name}-public_rt-vpc"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
    Env  = var.environment
  }
}
