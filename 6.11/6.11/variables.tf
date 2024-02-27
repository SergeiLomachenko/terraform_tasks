variable "aws_region" {
  description = "eu-north-1"
  type        = string
}

variable "devgroup" {
    type        = string
    default     = "dev"
}

variable "devopsgroup" {
    type        = string
    default     = "devops"
}

variable "users" {
  default = ["Givi", "Selin", "Slava", "Rita"]
  type        = list(string)
  description = "list of user names"
}

variable "secret_key" {
  type = string
  sensitive = true
}

variable "access_key" {
  type = string
  sensitive = true
}
