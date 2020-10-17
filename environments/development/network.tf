module "network_simple" {
  source              = "../../module/network/simple"
  sys_name            = var.sys_name
  env                 = var.env
  vpc_cidr            = "10.0.0.0/16"
  subnet_public_cidr  = "10.0.10.0/24"
  subnet_public_az    = "${var.region}a"
  subnet_private_cidr = "10.0.20.0/24"
  subnet_private_az   = "${var.region}a"
}

module "security_group" {
  source      = "../../module/network/security_group"
  sys_name    = var.sys_name
  env         = var.env
  name        = "${var.sys_name}-sg"
  vpc_id      = module.network_simple.vpc_id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}
