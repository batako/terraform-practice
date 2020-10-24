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

# プライベートサブネットの作成
resource "aws_subnet" "private" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.az
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.sys_name}-private-subnet-${split("-", var.az)[length(split("-", var.az)) - 1]}"
    Env  = var.env
  }
}

# プライベートテーブルの作成
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.sys_name}-private-rtb-${split("-", var.az)[length(split("-", var.az)) - 1]}"
    Env  = var.env
  }
}

# プライベートサブネットとプライベートテーブルの紐付け
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
