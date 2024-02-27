variable "devops_usernames" {
  type = list(string)
  default = ["Slava","Rita"]
}

variable "developer_usernames" {
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