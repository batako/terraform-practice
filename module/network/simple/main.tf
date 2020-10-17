variable "sys_name" {
  type = string
}
variable "env" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "subnet_public_cidr" {
  type = string
}
variable "subnet_public_az" {
  type = string
}
variable "subnet_private_cidr" {
  type = string
}
variable "subnet_private_az" {
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

module "public_subnet" {
  source              = "../public_subnet/"
  sys_name            = var.sys_name
  env                 = var.env
  vpc_id              = aws_vpc.template.id
  subnet_public_cidr  = "10.0.10.0/24"
  subnet_public_az    = "ap-northeast-1a"
  internet_gateway_id = aws_internet_gateway.template.id
}

module "private_subnet" {
  source              = "../private_subnet/"
  sys_name            = var.sys_name
  env                 = var.env
  vpc_id              = aws_vpc.template.id
  subnet_private_cidr = "10.0.20.0/24"
  subnet_private_az   = "ap-northeast-1a"
}
