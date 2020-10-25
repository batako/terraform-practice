terraform {
  required_version = "= 0.13.4"
}

module "pair_key" {
  source   = "../../module/pair_key"
  key_name = var.key_name
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = module.pair_key.public_key_openssh
}
