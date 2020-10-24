module "network_base" {
  source   = "../../module/network/base"
  sys_name = var.sys_name
  env      = var.env
  vpc_cidr = "10.0.0.0/16"
}

module "public_subnet_a" {
  source     = "../../module/network/public_subnet"
  sys_name   = var.sys_name
  env        = var.env
  vpc_id     = module.network_base.vpc_id
  cidr_block = "10.0.10.0/24"
  az         = "${var.region}a"
}

module "private_subnet_a" {
  source     = "../../module/network/private_subnet"
  sys_name   = var.sys_name
  env        = var.env
  vpc_id     = module.network_base.vpc_id
  cidr_block = "10.0.20.0/24"
  az         = "${var.region}a"
}

module "public_subnet_c" {
  source     = "../../module/network/public_subnet"
  sys_name   = var.sys_name
  env        = var.env
  vpc_id     = module.network_base.vpc_id
  cidr_block = "10.0.11.0/24"
  az         = "${var.region}c"
}

module "private_subnet_c" {
  source     = "../../module/network/private_subnet"
  sys_name   = var.sys_name
  env        = var.env
  vpc_id     = module.network_base.vpc_id
  cidr_block = "10.0.21.0/24"
  az         = "${var.region}c"
}

module "public_default_route_table" {
  source              = "../../module/network/public_default_route_table"
  sys_name            = var.sys_name
  env                 = var.env
  vpc_id              = module.network_base.vpc_id
  internet_gateway_id = module.network_base.internet_gateway_id
}

resource "aws_route_table_association" "public_subnet_a" {
  subnet_id      = module.public_subnet_a.id
  route_table_id = module.public_default_route_table.id
}

resource "aws_route_table_association" "public_subnet_c" {
  subnet_id      = module.public_subnet_c.id
  route_table_id = module.public_default_route_table.id
}
