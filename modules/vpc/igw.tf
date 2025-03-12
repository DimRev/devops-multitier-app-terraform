## INTERNET GATEWAY

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_eip" "nat_eip" {
  tags = {
    Name = "${var.public_subnet_name}-nat-eip"
  }
}
