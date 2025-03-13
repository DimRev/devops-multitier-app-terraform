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

data "template_file" "nginx_userdata" {
  template = file("${path.module}/templates/nginx_userdata.tpl")
  vars = {
    s3_bucket = var.s3_bucket_name
  }
}

resource "aws_key_pair" "my_key" {
  key_name   = var.key_pair_name
  public_key = file(var.public_key_path)
}


resource "aws_launch_template" "nginx_web_lt" {
  name_prefix   = "${var.nginx_lt_name_prefix}-"
  image_id      = data.aws_ami.amazon_linux_2_free_tier.id
  instance_type = var.nginx_lt_instance_type
  key_name      = aws_key_pair.my_key.key_name

  network_interfaces {
    # Remove or set to false if not using AWS Outposts
    associate_carrier_ip_address = false
    security_groups              = var.nginx_lt_security_groups
  }

  iam_instance_profile {
    name = var.nginx_lt_instance_profile_name
  }

  user_data = base64encode(data.template_file.nginx_userdata.rendered)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.nginx_lt_instance_name
    }
  }
}

