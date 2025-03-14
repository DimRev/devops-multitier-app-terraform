# PUBLIC
resource "aws_subnet" "public" {
  count  = length(var.public_subnet_obj_list)
  vpc_id = aws_vpc.main.id

  cidr_block              = var.public_subnet_obj_list[count.index].cidr_block
  availability_zone       = var.public_subnet_obj_list[count.index].availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_obj_list[count.index].name
    Env  = var.environment
  }
}

## PUBLIC ROUTE TABLE
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" # Change here
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = local.public_route_table_name
  }
}

resource "aws_route_table_association" "public_association" {
  count          = length(var.public_subnet_obj_list)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
