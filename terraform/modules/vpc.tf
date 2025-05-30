resource "aws_vpc" "hcl-hackathon-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "HCL-Hackathon-VPC"
  }
}

resource "aws_internet_gateway" "hcl-igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "HCL-Hackathon-IGW"
  }
  depends_on = [ aws_vpc.hcl-hackathon-vpc ]
}

resource "aws_nat_gateway" "hcl-ngw" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.example.id

  tags = {
    Name = "gw NAT"
  }
  depends_on = [aws_internet_gateway.hcl-igw]
}

resource "aws_egress_only_internet_gateway" "egress" {
  vpc_id = aws_vpc.hcl-hackathon-vpc.id

  tags = {
    Name = "main"
  }
  depends_on = [ aws_vpc.hcl-hackathon-vpc ]
}
resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.hcl-hackathon-vpc
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

    tags = {
        Name = "HCL-Hackathon-Public-Subnet"
    }
    depends_on = [aws_internet_gateway.hcl-igw]
}

resource "aws_subnet" "private-subnet2" {
  vpc_id            = aws_vpc.hcl-hackathon-vpc.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone = "us-east-1a"

    tags = {
        Name = "HCL-Hackathon-Private-Subnet"
    }
    depends_on = [aws_internet_gateway.hcl-igw]

}

resource "aws_route_table" "hcl-route" {
  vpc_id = aws_vpc.hcl-hackathon-vpc.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.hcl-igw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.egress.id
  }

  tags = {
    Name = "example"
  }
}

resource "aws_route_table_association" "hcl-route-public" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.hcl-route.id
  depends_on = [aws_route_table.hcl-route, aws_subnet.public-subnet]
}

resource "aws_route_table_association" "hcl-route-private" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.bar.id
}

