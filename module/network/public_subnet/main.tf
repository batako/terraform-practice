variable "sys_name" {
  type = string
}
variable "env" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "cidr_block" {
  type = string
}
variable "az" {
  type = string
}

resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.az

  tags = {
    Name = "${var.sys_name}-public-subnet-${split("-", var.az)[length(split("-", var.az)) - 1]}"
    Env  = var.env
  }
}
