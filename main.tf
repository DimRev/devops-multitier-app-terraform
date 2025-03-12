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

