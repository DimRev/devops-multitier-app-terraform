# PRIVATE

resource "aws_subnet" "private" {
  count  = length(var.private_subnet_obj_list)
  vpc_id = aws_vpc.main.id

  cidr_block              = var.private_subnet_obj_list[count.index].cidr_block
  availability_zone       = var.private_subnet_obj_list[count.index].availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = var.private_subnet_obj_list[count.index].name
  }
}

## PRIVATE ROUTE TABLE


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_association" {
  count          = length(var.public_subnet_obj_list)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
