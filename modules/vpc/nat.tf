resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id # First public subnet

  tags = {
    Name = "public-nat"
  }
}
