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

variable "ez_zone_16" {
    description = "setting EZ for private subnet"
    type = string
    default = "eu-north-1a"
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