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

# VPCの作成
resource "aws_vpc" "template" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.sys_name
    Env  = var.env
  }
}

# インターネットゲートウェイの作成
resource "aws_internet_gateway" "template" {
  vpc_id = aws_vpc.template.id

  tags = {
    Name = "${var.sys_name}-igw"
    Env  = var.env
  }
}

# パブリックサブネットの作成
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.template.id
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
  vpc_id = aws_vpc.template.id

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
  gateway_id             = aws_internet_gateway.template.id
  destination_cidr_block = "0.0.0.0/0"
}

# プライベートサブネットの作成
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.template.id
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
  vpc_id = aws_vpc.template.id

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
