variable "aws_region_1" {
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
    description = "setting EZ for private subnet"
    type = string
    default = "eu-north-1a"
}

variable "aws_region_2" {
    type = string
    default = "eu-central-1"
}

variable "ez_zone_2" {
    description = "setting EZ for private subnet"
    type = string
    default = "eu-central-1b"
}

variable "sergey_ami_id_1" {
    description = "ami_id"
    type = string
    default = "ami-06478978e5e72679a"
}

variable "sergey_ami_id_2" {
    description = "ami_id"
    type = string
    default = "ami-025a6a5beb74db87b"
}

variable "key_name" {
    description = "key name for instance"
    type = string
    default = "6_14"
}