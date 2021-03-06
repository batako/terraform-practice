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
variable "public_subnet_id" {
  type = string
}

module "private_subnet" {
  source     = "../private_subnet"
  sys_name   = var.sys_name
  env        = var.env
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block
  az         = var.az
}

module "private_nat" {
  source    = "../nat"
  sys_name  = var.sys_name
  env       = var.env
  az        = var.az
  subnet_id = var.public_subnet_id
}

resource "aws_route" "private" {
  route_table_id         = module.private_subnet.route_table_id
  nat_gateway_id         = module.private_nat.gateway_id
  destination_cidr_block = "0.0.0.0/0"
}
