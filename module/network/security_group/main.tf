variable "sys_name" {
  type = string
}
variable "env" {
  type = string
}
variable "name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "port" {
  type = number
}
variable "cidr_blocks" {
  type = list(string)
}

resource "aws_security_group" "default" {
  name   = var.name
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.sys_name}-sg"
    Env  = var.env
  }
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = var.cidr_blocks
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}
