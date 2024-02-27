provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}

module "ec2_instance" {
  source = "./sergey_modules/ec2_instance"
  ami_value = "ami-0c7217cdde317cfec"
  instance_type_value = "t2.micro"
  subnet_id_value = "subnet-0fc67d0460e5f732e"
}
