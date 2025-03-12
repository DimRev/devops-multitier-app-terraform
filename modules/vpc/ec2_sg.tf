resource "aws_security_group" "ec2_sg" {
  name        = "${var.vpc_name}-ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "Allow HTTPS from ALB"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow outbound to anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-ec2-sg"
  }
}