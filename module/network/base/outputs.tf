output "vpc_id" {
  value = aws_vpc.template.id
}

output "cidr_block" {
  value = var.vpc_cidr
}

output "internet_gateway_id" {
  value = aws_internet_gateway.template.id
}
