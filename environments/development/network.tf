module "network" {
  source              = "../../module/network/"
  sys_name            = var.sys_name
  env                 = var.env
  vpc_cidr            = "10.0.0.0/16"
  subnet_public_cidr  = "10.0.10.0/24"
  subnet_public_az    = "ap-northeast-1a"
  subnet_private_cidr = "10.0.20.0/24"
  subnet_private_az   = "ap-northeast-1a"
}
