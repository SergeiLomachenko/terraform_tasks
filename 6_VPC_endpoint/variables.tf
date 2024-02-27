variable "aws_region" {
    description = "varaible for aws region"
    type = string
    default = "us-east-1"
}

variable "ami" {
    type = string
    default = "ami-0c7217cdde317cfec"
}

variable "access_key" {
    type = string
    sensitive = true
}

variable "secret_key" {
    type = string
    sensitive = true
}

variable "key_name" {
    description = "varaible for key name"
    type = string
    default = "key_for_ec2"
}