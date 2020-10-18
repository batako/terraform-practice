variable "sys_name" {
  type = string
}
variable "env" {
  type = string
}
variable "vpc_cidr" {
  type = string
}

resource "aws_vpc" "template" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.sys_name
    Env  = var.env
  }
}

resource "aws_internet_gateway" "template" {
  vpc_id = aws_vpc.template.id

  tags = {
    Name = "${var.sys_name}-igw"
    Env  = var.env
  }
}
