resource "aws_security_group" "bastion_sg" {
  name        = local.bastion_sg_name
  description = "Security group for the Bastion host"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow SSH from allowed IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_allowed_ssh_cidrs
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.bastion_sg_name
    Env  = var.environment
  }
}


