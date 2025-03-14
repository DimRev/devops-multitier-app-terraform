locals {
  jenkins_name     = "${var.environment}-${var.jenkins_name}-jenkins-jenkins"
  jenkins_sg_name  = "${var.environment}-${var.jenkins_name}-jenkins_sg-jenkins"
  jenkins_eip_name = "${var.environment}-${var.jenkins_name}-jenkins_eip-jenkins"
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

data "template_file" "jenkins_userdata" {
  template = file("${path.module}/templates/jenkins_userdata.tpl")
  vars = {
    s3_bucket = var.s3_bucket_name
  }
}

resource "aws_eip" "jenkins_eip" {
  tags = {
    Name = local.jenkins_eip_name
    Env  = var.environment
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.jenkins.id
  allocation_id = aws_eip.jenkins_eip.id
}

resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.amazon_linux_2_free_tier.id
  instance_type               = "t3.micro"
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = false



  user_data = base64encode(data.template_file.jenkins_userdata.rendered)

  tags = {
    Name = local.jenkins_name
    Env  = var.environment
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = local.jenkins_sg_name
  description = "Security group for the Jenkins server"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow TCP for Jenkins Agents from anywhere"
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    Name = local.jenkins_sg_name
    Env  = var.environment
  }
}
