resource "aws_security_group" "rds_sg" {
  name        = "${var.vpc_name}-rds-sg"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow inbound from EC2 instances"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    description     = "Allow outbound traffic to anywhere"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-rds-sg"
  }
}