provider "aws" {
    region = var.aws_region
    access_key = var.access_key
    secret_key = var.secret_key
}

resource "aws_vpc" "sergey_vpc_14" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "Sergey_VPS"
    }
}

resource "aws_internet_gateway" "sergey_igw_14" {
    vpc_id = aws_vpc.sergey_vpc_14.id

    tags = {
        Name = "Sergey_IGW"
    }
}

resource "aws_route_table" "sergey_table_14" {
    vpc_id = aws_vpc.sergey_vpc_14.id

    route {
        cidr_block = "0.0.0.0/16"
        gateway_id = aws_internet_gateway.sergey_igw_14.id
    }

    tags = {
        Name = "Sergey_Table"
    }
}

resource "aws_subnet" "sergey_subnet_14" {
    vpc_id = aws_vpc.sergey_vpc_14.id
    cidr_block = "10.0.0.0/16"
    availability_zone = var.ez_zone_14
    map_public_ip_on_launch = true

    tags = {
        Name = "Sergey_Private_Subnet"
    }
}

resource "aws_route_table_association" "sergey_association" {
    subnet_id = aws_subnet.sergey_subnet_14.id
    route_table_id = aws_route_table.sergey_table_14.id
}

resource "aws_security_group" "sergey_security_group_14" {
    vpc_id = aws_vpc.sergey_vpc_14.id

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
        Name = "Sergey_Security_Group"
    }
}

resource "aws_instance" "sergey_instance_14" {
    ami = var.sergey_ami_id
    instance_type = "t3.micro"
    subnet_id = aws_subnet.sergey_subnet_14.id
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.sergey_security_group_14.id]
    associate_public_ip_address = true 
    
    user_data = <<-EOF
        #!/bin/bash
        sudo apt-get update -y
        sudo apt-get install nginx -y
        sudo systemctl start nginx 
    EOF

    tags = {
        Name = "Sergey_aws_instance_WEB"
    }
}

resource "aws_flow_log" "sergey_aws_flow" {
    depends_on = [aws_subnet.sergey_subnet_14, aws_security_group.sergey_security_group_14]
    vpc_id = aws_vpc.sergey_vpc_14.id
    iam_role_arn = aws_iam_role.sergey_role.arn
    traffic_type = "ALL"
    log_destination = aws_cloudwatch_log_group.sergey_cloudwatch_group.arn
}

resource "aws_cloudwatch_log_group" "sergey_cloudwatch_group" {
    name = "sergey_cloudwatch_group"
}

resource "aws_iam_role" "sergey_role" {
    name = "sergey-role"

    assume_role_policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "vpc-flow-logs.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "flow_logs_policy_attachment" {
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
    role = aws_iam_role.sergey_role.name
}

output "public_ip" {
    value = aws_instance.sergey_instance_14.public_ip
}




