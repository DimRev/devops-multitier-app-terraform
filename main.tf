module "vpc" {
  source = "./modules/vpc"
  # VPC
  vpc_cidr_block = var.vpc_cidr_block
  vpc_name       = var.vpc_name
  # Public Subnet
  public_subnet_cidr_block        = var.public_subnet_cidr_block
  public_subnet_availability_zone = var.public_subnet_availability_zone
  public_subnet_name              = var.public_subnet_name
  # Private Subnet
  private_subnet_cidr_block        = var.private_subnet_cidr_block
  private_subnet_availability_zone = var.private_subnet_availability_zone
  private_subnet_name              = var.private_subnet_name
}

module "alb" {
  source          = "./modules/alb"
  security_groups = [module.vpc.alb_sg_id]
  vpc_id          = module.vpc.vpc_id
  subnets         = [module.vpc.public_subnet_id]

  enable_https        = false
  healthy_threshold   = 3
  unhealthy_threshold = 2
  health_check_path   = "/"
}


module "asg" {
  source               = "./modules/asg"
  asg_name             = "nginx-app-asg"
  asg_instance_name    = "nginx-app-asg-instance"
  asg_max_size         = 4
  asg_desired_capacity = 3
  asg_min_size         = 2
  asg_subnets          = [module.vpc.public_subnet_id]

  nginx_lt_instance_type = "t3.micro"
  nginx_lt_name_prefix   = "nginx-lt"
  nginx_lt_instance_name = "nginx-lt-instance"

  scale_out_adjustment = 1
  scale_in_adjustment  = -1
  cpu_low_threshold    = 20
  cpu_high_threshold   = 80

  target_group_arns = [module.alb.target_group_arn]
}
