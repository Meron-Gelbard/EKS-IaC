resource "aws_subnet" "private-a" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${var.cluster_name}-private-a"
  }
}

resource "aws_subnet" "private-b" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "${var.cluster_name}-private-b"
  }
}

resource "aws_subnet" "public-a" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.cluster_name}-public-a"
  }
}

resource "aws_subnet" "public-b" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.cluster_name}-public-b"
  }
}