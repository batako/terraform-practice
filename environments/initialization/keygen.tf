terraform {
  required_version = "= 0.13.4"
}

module "pair_key" {
  source   = "../../module/pair_key"
  key_name = "terraform"
}
