variable "sys_name" {
  type = string
}
variable "env" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "subnet_public_cidr" {
  type = string
}
variable "subnet_public_az" {
  type = string
}
variable "internet_gateway_id" {
  type = string
}

# パブリックサブネットの作成
resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_public_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.subnet_public_az

  tags = {
    Name = "${var.sys_name}-public-subnet-${split("-", var.subnet_public_az)[length(split("-", var.subnet_public_az)) - 1]}"
    Env  = var.env
  }
}

# パブリックルートテーブルの作成
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.sys_name}-public-rtb"
    Env  = var.env
  }
}

# パブリックサブネットとパブリックルートテーブルを紐付け
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# パブリックルートのデフォルトルートを設定
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = var.internet_gateway_id
  destination_cidr_block = "0.0.0.0/0"
}
