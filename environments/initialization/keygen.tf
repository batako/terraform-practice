terraform {
  required_version = "= 0.13.4"
}

module "pair_key" {
  source   = "../../module/pair_key"
  key_name = "tf-dev"
}

resource "aws_key_pair" "generated_key" {
  key_name   = "tf-dev"
  public_key = module.pair_key.public_key_openssh
}
