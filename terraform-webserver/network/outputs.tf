output "vpc_id" {
  value = aws_vpc.webserver-vpc.id
}

output "subnet_ids" {
  value = aws_subnet.webserver-public-subnet[*].id
}

output "cidr_block" {
  value = aws_vpc.webserver-vpc.cidr_block
}
