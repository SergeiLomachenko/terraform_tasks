provider "aws" {
    region = var.aws_region
    access_key = var.access_key
    secret_key = var.secret_key
}

#Создание VPC 
resource "aws_vpc" "vpc_12" {
    cidr_block = "172.16.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Namme = "sergey_vpc"
    }
}

#Создание интернет-шлюза
resource "aws_internet_gateway" "gateway_12" {
    vpc_id = aws_vpc.vpc_12.id

    tags = {
        Name = "sergey_igw" 
    }
}

resource "aws_subnet" "public_subnet1" {
    vpc_id = aws_vpc.vpc_12.id
    cidr_block = "172.16.1.0/24"
    availability_zone = "eu-north-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "sergey_public_subnet1"
    }
} 

resource "aws_subnet" "public_subnet2" {
    vpc_id = aws_vpc.vpc_12.id
    cidr_block = "172.16.2.0/24"
    availability_zone = "eu-north-1b"
    map_public_ip_on_launch = true

    tags = {
        Name = "sergey_public_subnet2"
    }
}

#Создание маршрутизационной таблицы для публичных подсетей 
resource "aws_route_table" "public_rout_table" {
    vpc_id = aws_vpc.vpc_12.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gateway_12.id
    }

    tags = {
        Name = "public_rout_table"
    }
}

#Привязка публичных ключей к маршрутизационной таблице
resource "aws_route_table_association" "public_subnet1_association" {
    subnet_id = aws_subnet.public_subnet1.id
    route_table_id = aws_route_table.public_rout_table.id
}

resource "aws_route_table_association" "public_subnet_assotiation" {
    subnet_id = aws_subnet.public_subnet2.id
    route_table_id = aws_route_table.public_rout_table.id
}

