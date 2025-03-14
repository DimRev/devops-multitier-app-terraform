locals {
  bastion_name    = "${var.environment}-${var.bastion_name}-bastion-bastion"
  bastion_sg_name = "${var.environment}-${var.bastion_name}-bastion_sg-bastion"
}

data "aws_ami" "amazon_linux_2_free_tier" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = local.bastion_sg_name
  description = "Security group for the Bastion host"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH from allowed IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.bastion_name
    Env  = var.environment
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux_2_free_tier.id
  instance_type               = "t3.micro"
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = local.bastion_name
    Env  = var.environment
  }
}
