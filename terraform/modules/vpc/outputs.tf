output "vpc_id" {
  value = aws_vpc.devops_vpc.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}
