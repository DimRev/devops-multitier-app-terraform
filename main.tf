module "vpc" {
  source = "./modules/vpc"
  # VPC
  vpc_cidr_block = var.vpc_cidr_block
  vpc_name = var.vpc_name
  # Public Subnet
  public_subnet_cidr_block = var.public_subnet_cidr_block
  public_subnet_availability_zone = var.public_subnet_availability_zone
  public_subnet_name = var.public_subnet_name
  # Private Subnet
  private_subnet_cidr_block = var.private_subnet_cidr_block
  private_subnet_availability_zone = var.private_subnet_availability_zone
  private_subnet_name = var.private_subnet_name
}

module "alb" {
  source = "./modules/alb"
  security_groups = [ module.vpc.alb_sg_id ]
  vpc_id = module.vpc.vpc_id
  subnets = [ module.vpc.public_subnet_id ]

  enable_https = false
  healthy_threshold = 3
  unhealthy_threshold = 2
  health_check_path = "/"
}

