
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name ="my-vpc"
  }
}

resource "aws_subnet" "my-subnet1" {
  vpc_id                     =  aws_vpc.my-vpc.id
  cidr_block                 =  "10.0.0.0/24"
  availability_zone          =  "us-east-1a"
  map_public_ip_on_launch    =  true

   tags = {
     Name ="my-subnet1"
   }
}

resource "aws_subnet" "my-subnet2" {
  vpc_id                     = aws_vpc.my-vpc.id
  cidr_block                 = "10.0.1.0/24"
  availability_zone          = "us-east-1b"
  map_public_ip_on_launch    = true

  tags = {
    Name = "my-subnet2"
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }

  tags = {
    Name ="RT"
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.my-subnet1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.my-subnet2.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.my-vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "Web-sg"
  }
}

