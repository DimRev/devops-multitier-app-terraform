module "vpc" {
  source = "./modules/vpc"
  # VPC
  vpc_cidr_block = var.vpc_cidr_block
  vpc_name       = var.vpc_name

  bastion_allowed_ssh_cidrs = ["0.0.0.0/0"] # TODO: Add your IP range here

  # Public Subnet
  public_subnet_obj_list = var.public_subnet_obj_list
  # Private Subnet
  private_subnet_obj_list = var.private_subnet_obj_list
  environment             = var.environment
}

module "nginx_alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id

  alb_security_groups = [module.vpc.alb_sg_id]
  alb_subnets         = module.vpc.public_subnet_ids
  alb_log_bucket      = data.aws_s3_bucket.s3.bucket

  enable_https        = false
  healthy_threshold   = 3
  unhealthy_threshold = 2
  health_check_path   = "/"
  environment         = var.environment
}


module "nginx_asg" {
  source               = "./modules/asg"
  asg_name             = var.asg_name
  asg_instance_name    = var.asg_instance_name
  asg_max_size         = 4
  asg_desired_capacity = 3
  asg_min_size         = 2
  asg_subnets          = module.vpc.private_subnet_ids

  nginx_lt_instance_type         = "t3.micro"
  nginx_lt_name_prefix           = var.nginx_lt_name_prefix
  nginx_lt_instance_name         = var.nginx_lt_instance_name
  nginx_lt_security_groups       = [module.vpc.ec2_sg_id]
  nginx_lt_instance_profile_name = module.security.iam_instance_profile

  key_pair_name   = var.key_pair_name
  public_key_path = var.public_key_path

  s3_bucket_name = data.aws_s3_bucket.s3.bucket

  scale_out_adjustment = 1
  scale_in_adjustment  = -1
  cpu_low_threshold    = 20
  cpu_high_threshold   = 80

  target_group_arns = [module.nginx_alb.target_group_arn]
  environment       = var.environment
}

module "rds" {
  source                 = "./modules/rds"
  db_engine              = var.db_engine
  db_engine_version      = var.db_engine_version
  db_root_username       = var.db_root_username
  db_root_password       = var.db_root_password
  rds_security_group_ids = [module.vpc.rds_sg_id]
  rds_name               = var.rds_name
  subnet_ids             = module.vpc.private_subnet_ids
  environment            = var.environment
}


data "aws_s3_bucket" "s3" {
  bucket = var.s3_bucket_name
}

module "security" {
  source                = "./modules/security"
  ec2_role_name         = var.ec2_role_name
  s3_bucket_arn         = data.aws_s3_bucket.s3.arn
  s3_bucket_id          = data.aws_s3_bucket.s3.id
  instance_profile_name = var.ec2_instance_profile_name
  environment           = var.environment
}

module "bastion" {
  source           = "./modules/ec2"
  ec2_name         = "bastion"
  key_name         = module.nginx_asg.key_pair_name
  public_subnet_id = module.vpc.public_subnet_ids[0]
  ec2_sg_id        = module.vpc.bastion_sg_id
  assign_eip       = true
  environment      = var.environment
}

data "template_file" "jenkins_userdata" {
  template = file("${path.module}/templates/jenkins_userdata.tpl")
}

module "jenkins" {
  source            = "./modules/ec2"
  ec2_name          = "jenkins"
  key_name          = module.nginx_asg.key_pair_name
  public_subnet_id  = module.vpc.public_subnet_ids[0]
  ec2_sg_id         = module.vpc.jenkins_sg_id
  ec2_instance_type = "t3.medium"
  assign_eip        = true
  environment       = var.environment

  base64encoded_user_data = base64encode(data.template_file.jenkins_userdata.rendered)
}
