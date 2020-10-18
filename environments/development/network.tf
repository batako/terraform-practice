module "network_base" {
  source   = "../../module/network/base"
  sys_name = var.sys_name
  env      = var.env
  vpc_cidr = "10.0.0.0/16"
}

module "public_subnet_a" {
  source              = "../../module/network/public_subnet/"
  sys_name            = var.sys_name
  env                 = var.env
  vpc_id              = module.network_base.vpc_id
  subnet_public_cidr  = "10.0.10.0/24"
  subnet_public_az    = "${var.region}a"
  internet_gateway_id = module.network_base.aws_internet_gateway_id
}

module "private_subnet_a" {
  source              = "../../module/network/private_subnet/"
  sys_name            = var.sys_name
  env                 = var.env
  vpc_id              = module.network_base.vpc_id
  subnet_private_cidr = "10.0.20.0/24"
  subnet_private_az   = "${var.region}a"
}

module "public_subnet_c" {
  source              = "../../module/network/public_subnet"
  sys_name            = var.sys_name
  env                 = var.env
  vpc_id              = module.network_base.vpc_id
  subnet_public_cidr  = "10.0.11.0/24"
  subnet_public_az    = "${var.region}c"
  internet_gateway_id = module.network_base.aws_internet_gateway_id
}

module "private_subnet_c" {
  source              = "../../module/network/private_subnet"
  sys_name            = var.sys_name
  env                 = var.env
  vpc_id              = module.network_base.vpc_id
  subnet_private_cidr = "10.0.21.0/24"
  subnet_private_az   = "${var.region}c"
}
