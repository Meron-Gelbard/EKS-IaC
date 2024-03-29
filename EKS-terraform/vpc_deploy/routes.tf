resource "aws_route_table" "private" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "${var.cluster_name}-private-RT"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.cluster_name}-public-RT"
  }
}

resource "aws_route_table_association" "public-a-asso" {
 subnet_id      = aws_subnet.public-a.id
 route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-b-asso" {
 subnet_id      = aws_subnet.public-b.id
 route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private-a-asso" {
  subnet_id      = aws_subnet.private-a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-b-asso" {
  subnet_id      = aws_subnet.private-b.id
  route_table_id = aws_route_table.private.id
}