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
variable "internet_gateway_id" {
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

module "public_default_route_table" {
  source              = "../public_default_route_table"
  sys_name            = var.sys_name
  env                 = var.env
  vpc_id              = var.vpc_id
  internet_gateway_id = var.internet_gateway_id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = module.public_default_route_table.id
}
