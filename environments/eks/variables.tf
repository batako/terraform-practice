variable "project" {
  default = "eks"
}

variable "environment" {
  default = "dev"
}

variable "region" {
  default = "ap-northeast-1"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "num_subnets" {
  default = 2
}

locals {
  base_tags = {
    Project     = var.project
    Terraform   = "true"
    Environment = var.environment
  }
  base_name = "${var.project}-${var.environment}"
  default_tags = merge(
    local.base_tags,
    map("Name", local.base_name)
  )
  cluster_name    = "${local.base_name}-cluster"
  cluster_version = "1.18"
}

data "aws_availability_zones" "available" {}
