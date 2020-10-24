variable "sys_name" {
  type = string
}
variable "env" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "internet_gateway_id" {
  type = string
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.sys_name}-public-rtb"
    Env  = var.env
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = var.internet_gateway_id
  destination_cidr_block = "0.0.0.0/0"
}
