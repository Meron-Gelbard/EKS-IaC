resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.cluster_name}-IGW"
  }
}

resource "aws_eip" "natgw-eip" {
  vpc = true
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgw-eip.id
  subnet_id     = aws_subnet.public-a.id

  tags = {
    Name = "${var.cluster_name}-NATGW"
  }

  depends_on = [aws_internet_gateway.igw]
}
