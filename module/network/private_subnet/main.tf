variable "sys_name" {
  type = string
}
variable "env" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "subnet_private_cidr" {
  type = string
}
variable "subnet_private_az" {
  type = string
}

# プライベートサブネットの作成
resource "aws_subnet" "private" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_private_cidr
  availability_zone       = var.subnet_private_az
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.sys_name}-private-subnet-${split("-", var.subnet_private_az)[length(split("-", var.subnet_private_az)) - 1]}"
    Env  = var.env
  }
}

# プライベートテーブルの作成
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.sys_name}-private-rtb"
    Env  = var.env
  }
}

# プライベートサブネットとプライベートテーブルの紐付け
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
