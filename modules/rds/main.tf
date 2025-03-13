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
    Name = "${var.vpc_name}-rds-instance"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.vpc_name}-rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.vpc_name}-rds-subnet-group"
  }
}

