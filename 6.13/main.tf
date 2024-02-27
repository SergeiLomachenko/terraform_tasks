provider "aws" {
    region = var.aws_region
    access_key = var.access_key
    secret_key = var.secret_key
}

#Создание VPC 
resource "aws_vpc" "vpc_13" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Namme = "sergey_vpc"
    }
}

#Создание интернет-шлюза
resource "aws_internet_gateway" "gateway_13" {
    vpc_id = aws_vpc.vpc_13.id

    tags = {
        Name = "sergey_igw" 
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.vpc_13.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-north-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "sergey_public_subnet"
    }
} 

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.vpc_13.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-north-1b"
    map_public_ip_on_launch = false

    tags = {
        Name = "sergey_private_subnet"
    }
}

# Создание маршрутизационной таблицы для публичной подсети
resource "aws_route_table" "sergey_public_route_table" {
  vpc_id = aws_vpc.vpc_13.id

  tags = {
    Name = "Sergey_route_table"
  }
}

#Создание маршрутизационной таблицы для публичных подсетей 
resource "aws_route" "route_to_internet" {
    route_table_id = aws_route_table.sergey_public_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway_13.id
}

# Связь маршрутизационной таблицы с публичной подсетью
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.sergey_public_route_table.id
}

#Создание Network ACL
resource "aws_network_acl" "sergey_acl" {
    vpc_id = aws_vpc.vpc_13.id

    egress {
      protocol   = "tcp"
      rule_no    = 200
      action     = "allow"
      cidr_block = "10.0.0.0/28"
      from_port  = 443
      to_port    = 443
    }

  ingress {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "10.0.0.0/28"
      from_port  = 80
      to_port    = 80
    }

    tags = {
        Name = "Sergey_NACL"
    }
}


