locals {
  ec2_name = "${var.environment}-${var.ec2_name}-ec2-ec2"
  ec2_eip  = "${var.environment}-${var.ec2_name}-ec2_eip-ec2"
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

resource "aws_instance" "ec2_instance" {
  ami                    = data.aws_ami.amazon_linux_2_free_tier.id
  instance_type          = var.ec2_instance_type
  key_name               = var.key_name
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.ec2_sg_id]
  # If we're assigning an EIP, disable the automatic public IP assignment.
  associate_public_ip_address = var.assign_eip ? false : true

  # Conditionally assign user data if provided
  user_data_base64 = var.base64encoded_user_data != "" ? var.base64encoded_user_data : null

  tags = {
    Name = local.ec2_name
    Env  = var.environment
  }
}

resource "aws_eip" "ece_ec2" {
  count = var.assign_eip ? 1 : 0

  tags = {
    Name = local.ec2_eip
    Env  = var.environment
  }
}

resource "aws_eip_association" "eip_assoc" {
  count = var.assign_eip ? 1 : 0

  instance_id   = aws_instance.ec2_instance.id
  allocation_id = aws_eip.ece_ec2[0].id
}
