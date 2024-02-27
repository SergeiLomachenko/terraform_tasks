variable "aws_region" {
  type = string
  default = "eu-north-1"
}

variable "devops_names" {
  type = list(string)
  default = ["Slava","Rita"]
}

variable "developer_names" {
  type = list(string)
  default = ["Givi","Selin"]
}

variable "secret_key" {
  type = string
  sensitive = true
}

variable "access_key" {
  type = string
  sensitive = true
}