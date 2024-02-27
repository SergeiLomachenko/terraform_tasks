provider "aws" {
    region = var.aws_region
    access_key = var.access_key
    secret_key = var.secret_key
}

resource "aws_vpc" "sergey_vpc_1" {
    cidr_block = "192.168.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "Sergey_VPS_1"
    }
}

resource "aws_internet_gateway" "sergey_igw_16" {
    vpc_id = aws_vpc.sergey_vpc_1.id

    tags = {
        Name = "Sergey_IGW"
    }
}

resource "aws_route_table" "sergey_table_1" {
    vpc_id = aws_vpc.sergey_vpc_1.id
   
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.sergey_igw_16.id
    }
    
    tags = {
        Name = "Sergey_Table_1"
    }
}

resource "aws_route_table_association" "sergey_association_1" {
    subnet_id = aws_subnet.sergey_subnet_1.id
    route_table_id = aws_route_table.sergey_table_1.id
}

resource "aws_subnet" "sergey_subnet_1" {
    vpc_id = aws_vpc.sergey_vpc_1.id
    cidr_block = "192.168.0.0/24"
    availability_zone = var.ez_zone_1
    map_public_ip_on_launch = true

    tags = {
        Name = "Sergey_Subnet_1"
    }
}

resource "aws_subnet" "sergey_subnet_2" {
    vpc_id = aws_vpc.sergey_vpc_1.id
    cidr_block = "192.168.1.0/24"
    availability_zone = var.ez_zone_2
    map_public_ip_on_launch = true

    tags = {
        Name = "Sergey_Subnet_2"
    }
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

resource "aws_instance" "sergey_instance_1" {
    ami = var.sergey_ami_id
    instance_type = "t3.micro"
    subnet_id = aws_subnet.sergey_subnet_1.id
    security_groups = [aws_security_group.sergey_security_group_1.id]

    metadata_options {
      http_endpoint               = "enabled"
      http_tokens                 = "required"
      http_put_response_hop_limit = 2
    } 

    tags = {
        Name = "Sergey_aws_instance_1"
    }

    user_data = <<-EOF
      #!/bin/bash
      sudo yum install httpd -y
      sudo service httpd start
      echo "<html><head><title>My Web Page</title></head><body><h1>Hello from EC2!</h1></body></html>" | sudo tee /var/www/html/index.html
    EOF    
}



