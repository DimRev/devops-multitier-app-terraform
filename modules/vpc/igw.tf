
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = local.igw_name
    Env  = var.environment
  }
}

resource "aws_eip" "nat_eip" {
  tags = {
    Name = local.nat_eip_name
    Env  = var.environment
  }
}

