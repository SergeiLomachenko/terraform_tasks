variable "aws_region" {
    type = string
    default = "eu-north-1"
}

variable "access_key" {
    type = string
    sensitive = true
}

variable "secret_key" {
    type = string
    sensitive = true
}

variable "ez_zone_1" {
    description = "setting EZ for first subnet"
    type = string
    default = "eu-north-1a"
}

variable "ez_zone_2" {
    description = "setting EZ for second subnet"
    type = string
    default = "eu-north-1b"
}

variable "sergey_ami_id" {
    description = "ami_id"
    type = string
    default = "ami-06478978e5e72679a"
}

variable "key_name" {
    description = "key name for instance"
    type = string
    default = "6_14"
}