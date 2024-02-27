provider "aws" {
    region = var.aws_region
    access_key = var.access_key
    secret_key = var.secret_key
}

resource "aws_vpc" "sergey_vpc_1" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "Sergey_VPS_1"
    }
}

resource "aws_vpc" "sergey_vpc_2" {
    cidr_block = "10.1.0.0/16"

    tags = {
        Name = "Sergey_VPC_2"
    }
}

resource "aws_ec2_transit_gateway" "sergey_tgw" {
    description = "my first transit gateway"
}

recource "aws_es2_transit_gateway_vpc_attachment" "attachment_vpc1" {
    transit_gateway_id = aws_es2_transit_gateway.sergey_tgw.id
    vpc_id = aws_vpc.sergey_vpc_1.id
}

recource "aws_es2_transit_gateway_vpc_attachment" "attachment_vpc2 {
    transit_gateway_id = aws_es2_transit_gateway.sergey_tgw.id
    vpc_id = aws_vpc.sergey_vpc_2.id
}

resource "aws_internet_gateway" "sergey_igw_16" {
    vpc_id = aws_vpc.sergey_vpc_1.id

    tags = {
        Name = "Sergey_IGW"
    }
}

resource "aws_route_table" "sergey_table_1" {
    vpc_id = aws_vpc.sergey_vpc_1.id
    depends_on = [aws_vpc_peering_connection.peer]

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.sergey_igw_16.id
    }
    route {
        cidr_block                = "10.1.0.0/20"
        vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
    }

    tags = {
        Name = "Sergey_Table_1"
    }
}

resource "aws_route_table" "sergey_table_2" {
    vpc_id = aws_vpc.sergey_vpc_2.id
    depends_on = [aws_vpc_peering_connection.peer]

    route {
        cidr_block                = "10.0.0.0/20"
        vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
    }

    tags = {
        Name = "Sergey_Table_2"
    }
}

locals {
  subnet_associations = [
    {
      subnet_id      = aws_subnet.sergey_subnet_public.id
      route_table_id = aws_route_table.sergey_table_1.id
    },
    {
      subnet_id      = aws_subnet.sergey_subnet_private.id
      route_table_id = aws_route_table.sergey_table_2.id
    }
  ]
}

resource "aws_subnet" "sergey_subnet_public" {
    vpc_id = aws_vpc.sergey_vpc_1.id
    cidr_block = "10.0.0.0/20"
    availability_zone = var.ez_zone_16
    map_public_ip_on_launch = true

    tags = {
        Name = "Sergey_Public_Subnet"
    }
}

resource "aws_subnet" "sergey_subnet_private" {
    vpc_id = aws_vpc.sergey_vpc_2.id
    cidr_block = "10.1.0.0/20"
    availability_zone = var.ez_zone_16
    map_public_ip_on_launch = false

    tags = {
        Name = "Sergey_Private_Subnet"
    }
}

resource "aws_route_table_association" "sergey_association_1" {
    subnet_id = aws_subnet.sergey_subnet_public.id
    route_table_id = aws_route_table.sergey_table_1.id
}

resource "aws_route_table_association" "sergey_association_2" {
    subnet_id = aws_subnet.sergey_subnet_private.id
    route_table_id = aws_route_table.sergey_table_2.id
}

resource "aws_security_group" "sergey_security_group_1" {
    vpc_id = aws_vpc.sergey_vpc_1.id

    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

        egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }    

    tags = {
        Name = "Sergey_Security_Group_1"
    }
}

resource "aws_security_group" "sergey_security_group_2" {
    vpc_id = aws_vpc.sergey_vpc_2.id

    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

        egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }    

    tags = {
        Name = "Sergey_Security_Group_2"
    }
}

resource "aws_instance" "sergey_instance_1" {
    ami = var.sergey_ami_id
    instance_type = "t3.micro"
    subnet_id = aws_subnet.sergey_subnet_public.id
    security_groups = [aws_security_group.sergey_security_group_1.id]
      
    tags = {
        Name = "Sergey_aws_instance_1"
    }
}

resource "aws_instance" "sergey_instance_2" {
    ami = var.sergey_ami_id
    instance_type = "t3.micro"
    subnet_id = aws_subnet.sergey_subnet_private.id
    security_groups = [
        aws_security_group.sergey_security_group_2.id
    ]

    tags = {
        Name = "Sergey_aws_instance_2"
    }
}




