module "vpc" {
  source = "./modules/vpc"
  # VPC
  vpc_cidr_block = var.vpc_cidr_block
  vpc_name       = var.vpc_name
  # Public Subnet
  public_subnet_obj_list = var.public_subnet_obj_list
  # Private Subnet
  private_subnet_obj_list = var.private_subnet_obj_list
}

module "alb" {
  source          = "./modules/alb"
  security_groups = [module.vpc.alb_sg_id]
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnet_ids

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
  asg_subnets          = module.vpc.private_subnet_ids

  nginx_lt_instance_type         = "t3.micro"
  nginx_lt_name_prefix           = "nginx-lt"
  nginx_lt_instance_name         = "nginx-lt-instance"
  nginx_lt_security_groups       = [module.vpc.ec2_sg_id]
  nginx_lt_instance_profile_name = module.security.iam_instance_profile

  key_pair_name   = var.key_pair_name
  public_key_path = var.public_key_path

  s3_bucket_name = data.aws_s3_bucket.s3.bucket

  scale_out_adjustment = 1
  scale_in_adjustment  = -1
  cpu_low_threshold    = 20
  cpu_high_threshold   = 80

  target_group_arns = [module.alb.target_group_arn]
}

module "rds" {
  source                 = "./modules/rds"
  db_engine              = var.db_engine
  db_engine_version      = var.db_engine_version
  db_root_username       = var.db_root_username
  db_root_password       = var.db_root_password
  rds_security_group_ids = [module.vpc.rds_sg_id]
  vpc_name               = var.vpc_name
  subnet_ids             = module.vpc.private_subnet_ids
}


data "aws_s3_bucket" "s3" {
  bucket = var.s3_bucket_name
}

module "security" {
  source                = "./modules/security"
  ec2_role_name         = "ec2-role"
  s3_bucket_arn         = data.aws_s3_bucket.s3.arn
  instance_profile_name = "ec2-instance-profile"
}


module "bastion" {
  source            = "./modules/bastion"
  module_name       = "my-bastion"
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_ids[0]
  key_name          = module.asg.key_pair_name
  allowed_ssh_cidrs = ["0.0.0.0/0"] # TODO: Add your IP range here
}
