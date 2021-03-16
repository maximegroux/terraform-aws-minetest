provider "aws" {
  region = "eu-west-3"
}

resource "aws_vpc" "Johan" {
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "Johan-Network"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.Johan.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "eu-west-3a"

  tags = {
    Name = "Johan-Subnet"
  }
}

resource "aws_instance" "Minetest" {
  ami           = "ami-0d6aecf0f0425f42a"
  instance_type = "t2.xlarge"
  
  tags = {
      Name = "Minetest"
  }
  user_data = templatefile("${path.root}/minetest.sh", {
    })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.Johan.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Johan.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_security_group" "allow_Minetest_tcp" {
  name        = "allow_Minetest_tcp"
  description = "Allow Minetest_tcp inbound traffic"
  vpc_id      = aws_vpc.Johan.id

  ingress {
    description = "Minetest from VPC_tcp"
    from_port   = 30000
    to_port     = 30000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_Minetest_tcp"
  }
}

resource "aws_security_group" "allow_Minetest_udp" {
  name        = "allow_Minetest_udp"
  description = "Allow Minetest_tcp inbound traffic"
  vpc_id      = aws_vpc.Johan.id

  ingress {
    description = "Minetest from VPC_udp"
    from_port   = 30000
    to_port     = 30000
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_Minetest_udp"
  }
}