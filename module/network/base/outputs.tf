output "vpc_id" {
  value = aws_vpc.template.id
}

output "aws_internet_gateway_id" {
  value = aws_internet_gateway.template.id
}
