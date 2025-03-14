resource "aws_subnet" "private" {
  count  = length(var.private_subnet_obj_list)
  vpc_id = aws_vpc.main.id

  cidr_block              = var.private_subnet_obj_list[count.index].cidr_block
  availability_zone       = var.private_subnet_obj_list[count.index].availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = var.private_subnet_obj_list[count.index].name
    Env  = var.environment
  }
}

## PRIVATE ROUTE TABLE
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0" # Change here
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = local.private_route_table_name
  }
}

resource "aws_route_table_association" "private_association" {
  count          = length(var.private_subnet_obj_list)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
