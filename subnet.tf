#create public subnet
resource "aws_subnet" "public-subnet-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/20"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "${var.public}-a"
  }
}

resource "aws_subnet" "public-subnet-b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.16.0/20"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "${var.public}-b"
  }
}

resource "aws_subnet" "public-subnet-c" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.32.0/20"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "${var.public}-c"
  }
}

#create private subnet

resource "aws_subnet" "private-subnet-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.128.0/20"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "${var.private}-a"
  }
}
resource "aws_subnet" "private-subnet-b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.144.0/20"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "${var.private}-b"
  }
}
resource "aws_subnet" "private-subnet-c" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.160.0/20"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "${var.private}-c"
  }
}

#create internet-gateway for public-ip
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "wordpress-gw"
  }
}

#create-route-table 
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public-route-table"
  }
}

#route-table association
resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.public-subnet-a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public-b" {
  subnet_id      = aws_subnet.public-subnet-b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public-c" {
  subnet_id      = aws_subnet.public-subnet-c.id
  route_table_id = aws_route_table.public_route_table.id
}

#create elastic-id 
resource "aws_eip" "lb" {
  domain   = "vpc"
  tags = {
    Name = "wordpress-elb"
  }

  depends_on = [aws_internet_gateway.gw]
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public-subnet-a.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}


#route table for private subnet
resource "aws_route_table" "private_route_table-1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private-route-table-1"
  }
}

resource "aws_route_table" "private_route_table-2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private-route-table-2"
  }
}

resource "aws_route_table" "private_route_table-3" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private-route-table-3"
  }
}


#attach private subnets to route tables

resource "aws_route_table_association" "private-a" {
  subnet_id      = aws_subnet.private-subnet-a.id
  route_table_id = aws_route_table.private_route_table-1.id
}

resource "aws_route_table_association" "private-b" {
  subnet_id      = aws_subnet.private-subnet-b.id
  route_table_id = aws_route_table.private_route_table-2.id
}
resource "aws_route_table_association" "private-c" {
  subnet_id      = aws_subnet.private-subnet-c.id
  route_table_id = aws_route_table.private_route_table-3.id
}


