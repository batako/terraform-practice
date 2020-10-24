variable "sys_name" {
  type = string
}
variable "env" {
  type = string
}
variable "az" {
  type = string
}
variable "subnet_id" {
  type = string
}

resource "aws_eip" "template" {
  vpc = true

  tags = {
    Name = "${var.sys_name}-eip-nat-${split("-", var.az)[length(split("-", var.az)) - 1]}"
    Env  = var.env
  }
}

resource "aws_nat_gateway" "template" {
  subnet_id     = var.subnet_id
  allocation_id = aws_eip.template.id

  tags = {
    Name = "${var.sys_name}-ng-${split("-", var.az)[length(split("-", var.az)) - 1]}"
    Env  = var.env
  }
}
