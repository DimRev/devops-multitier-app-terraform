locals {
  rds_name    = "${var.environment}-${var.rds_name}-rds-rds"
  rds_sg_name = "${var.environment}-${var.rds_name}-rds_sg-rds"
}

resource "aws_db_instance" "default" {
  allocated_storage   = 10
  engine              = var.db_engine
  engine_version      = var.db_engine_version
  instance_class      = "db.t3.micro"
  username            = var.db_root_username
  password            = var.db_root_password
  skip_final_snapshot = true

  vpc_security_group_ids = var.rds_security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.default.name
  multi_az               = true

  tags = {
    Name = local.rds_name
    Env  = var.environment
  }
}

resource "aws_db_subnet_group" "default" {
  name       = local.rds_sg_name
  subnet_ids = var.subnet_ids

  tags = {
    Name = local.rds_sg_name
    Env  = var.environment
  }
}

