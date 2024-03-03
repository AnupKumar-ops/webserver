
## data source for availablity zones.
data "aws_availability_zones" "available" {
  state = "available"
}


## vpc creation
resource "aws_vpc" "webserver-vpc" {
  cidr_block       = var.app_arguments["network_arguments"]["vpc_cidr"]
  instance_tenancy = "default"

  tags = merge(var.app_arguments["tags"], { Name = "${var.app_arguments["common_name"]}-hdm-vpc" })
}


## subnets creation
resource "aws_subnet" "webserver-public-subnet" {
  vpc_id                  = aws_vpc.webserver-vpc.id
  count                   = var.app_arguments["network_arguments"]["subnet_count"]
  cidr_block              = cidrsubnet(var.app_arguments["network_arguments"]["vpc_cidr"], 2, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.app_arguments["tags"], { Name = "${var.app_arguments["common_name"]}-public-subnet-0${count.index}" })
}



## create internet gateway to attach to subnets for internet access
resource "aws_internet_gateway" "igw-webserver-vpc" {
  vpc_id = aws_vpc.webserver-vpc.id

  tags = merge(var.app_arguments["tags"], { Name = "igw-${var.app_arguments["common_name"]}" })
}


## create route tables
resource "aws_route_table" "webserver-public-rt" {
  vpc_id     = aws_vpc.webserver-vpc.id
  depends_on = [aws_internet_gateway.igw-webserver-vpc]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-webserver-vpc.id
  }

  tags = merge(var.app_arguments["tags"], { Name = "${var.app_arguments["common_name"]}-public-rt" })
}


## subnet association
resource "aws_route_table_association" "route_table_association_public" {
  count          = var.app_arguments["network_arguments"]["subnet_count"]
  subnet_id      = aws_subnet.webserver-public-subnet[count.index].id
  route_table_id = aws_route_table.webserver-public-rt.id
}

