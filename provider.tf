provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "pubsn" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "mypub"
  }
}


resource "aws_subnet" "pvtsn" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "mypvt"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "main"
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "private-route-table"
  }
}


resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.pubsn.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.pvtsn.id
  route_table_id = aws_route_table.private_rt.id
}


terraform {
  backend "s3" {
    bucket         = "vinny2005"
    key            = "dev_environment/terraform.tfstate"
    region         = "eu-north-1"
  }
}