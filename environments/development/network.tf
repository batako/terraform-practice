module "network_preset" {
  source   = "../../module/network/preset"
  sys_name = var.sys_name
  env      = var.env
  vpc_cidr = "10.0.0.0/16"
}

module "public_subnet_a" {
  source              = "../../module/network/public_subnet/"
  sys_name            = var.sys_name
  env                 = var.env
  vpc_id              = module.network_preset.vpc_id
  subnet_public_cidr  = "10.0.10.0/24"
  subnet_public_az    = "${var.region}a"
  internet_gateway_id = module.network_preset.aws_internet_gateway_id
}

module "private_subnet_a" {
  source              = "../../module/network/private_subnet/"
  sys_name            = var.sys_name
  env                 = var.env
  vpc_id              = module.network_preset.vpc_id
  subnet_private_cidr = "10.0.20.0/24"
  subnet_private_az   = "${var.region}a"
}

module "public_subnet_c" {
  source              = "../../module/network/public_subnet"
  sys_name            = var.sys_name
  env                 = var.env
  vpc_id              = module.network_preset.vpc_id
  subnet_public_cidr  = "10.0.11.0/24"
  subnet_public_az    = "${var.region}c"
  internet_gateway_id = module.network_preset.aws_internet_gateway_id
}

module "private_subnet_c" {
  source              = "../../module/network/private_subnet"
  sys_name            = var.sys_name
  env                 = var.env
  vpc_id              = module.network_preset.vpc_id
  subnet_private_cidr = "10.0.21.0/24"
  subnet_private_az   = "${var.region}c"
}

module "security_group_vpc" {
  source   = "../../module/network/security_group"
  sys_name = var.sys_name
  env      = var.env
  name     = "${var.sys_name}-sg-vpc"
  vpc_id   = module.network_preset.vpc_id
  # port        = 80
  # cidr_blocks = ["0.0.0.0/0"]
}
