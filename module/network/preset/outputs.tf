output "vpc_id" {
  value = aws_vpc.template.id
}

output "aws_internet_gateway_id" {
  value = aws_internet_gateway.template.id
}

output "subnet_public_id" {
  value = module.public_subnet.id
}

output "subnet_private_id" {
  value = module.private_subnet.id
}
