# PUBLIC

resource "aws_subnet" "public" {
  count  = length(var.public_subnet_obj_list)
  vpc_id = aws_vpc.main.id

  cidr_block              = var.public_subnet_obj_list[count.index].cidr_block
  availability_zone       = var.public_subnet_obj_list[count.index].availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_obj_list[count.index].name
  }
}

## PUBLIC ROUTE TABLE

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = var.vpc_cidr_block
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private_association" {
  count          = length(var.private_subnet_obj_list)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
