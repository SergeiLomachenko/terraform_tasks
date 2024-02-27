provider "aws" {
    region = var.aws_region
    access_key = var.access_key
    secret_key = var.secret_key
}

resource "tls_private_key" "rsa_4096_sergey" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "for_ec2" {
    key_name = var.key_name
    public_key = tls_private_key.rsa_4096_sergey.public_key_openssh
}

resource "local_file" "private_key" {
    content = tls_private_key.rsa_4096_sergey.private_key_pem
    filename = var.key_name
}

resource "aws_instance" "sergey_instance" {
    vpc_security_group_ids = [aws_security_group.sg_for_ec2.id]
    subnet_id = aws_subnet.sergey_subnet_ec2.id
    key_name = aws_key_pair.for_ec2.key_name
    
    ami = var.ami
    instance_type = "t3.micro"

    tags = {
        Name = "Sergey_instance"
    }
}

resource "aws_vpc" "sergey_vpc_ec2" {
    cidr_block = "192.168.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "Sergey_VPS_EC2"
    }
}

resource "aws_subnet" "sergey_subnet_ec2" {
    vpc_id = aws_vpc.sergey_vpc_ec2.id
    cidr_block = "192.168.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = false

    tags = {
        Name = "Sergey_EC2_Subnet"
    }
}

resource "aws_security_group" "sg_for_ec2" {
    name = "sec_group_ec2"
    description = "Security group for EC2"
    vpc_id = aws_vpc.sergey_vpc_ec2.id
    
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

        ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
     
}

resource "aws_subnet" "sergey_subnet_db" {
    vpc_id = aws_vpc.sergey_vpc_ec2.id
    cidr_block = "192.168.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = false

    tags = {
        Name = "Sergey_DB_Subnet"
    }
}

resource "aws_s3_bucket" "s3_bucket_sergey_16012024" {
  bucket = "sergey-bucket-16012024"
  tags = {
    "Name" = "DingDong"
  }
}

resource "aws_vpc_endpoint" "vpc_endpoint_gw" {
  vpc_id = aws_vpc.sergey_vpc_ec2.id
  service_name    = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = [aws_default_route_table.private_route_table.id]
}

resource "aws_default_route_table" "private_route_table" {
  default_route_table_id = aws_vpc.sergey_vpc_ec2.default_route_table_id
  tags = {
    "Name" = "Private Route Table"
  }
}



