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

resource "aws_launch_template" "nginx_web_lt" {
  name_prefix   = "${var.nginx_lt_name_prefix}-"
  image_id      = data.aws_ami.amazon_linux_2_free_tier.id
  instance_type = var.nginx_lt_instance_type

  network_interfaces {
    associate_carrier_ip_address = true
    security_groups              = var.nginx_lt_security_groups
  }

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install nginx -y
systemctl enable nginx
systemctl start nginx
cat <<EOM > /usr/share/nginx/html/index.html
<html>
  <head>
    <title>Hello, World!</title>
  </head>
  <body>
    <h1>Hello, World!</h1>
    <p>This is a simple web server running on an EC2 instance.</p>
  </body>
</html>
EOM
EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.nginx_lt_instance_name
    }
  }
}
