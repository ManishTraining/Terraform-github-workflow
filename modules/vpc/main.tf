# VPC block
resource "aws_vpc" "default" {
  cidr_block           = var.ipv4_primary_cidr_block
  enable_dns_hostnames = var.dns_hostnames_enabled

  tags = {
    Name = "${var.project_name}-vpc"
    project = var.project_name
  }
}

# Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnets_cidr)

  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.private_subnets_cidr[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index}"      #"${var.project_name}-private-${count.index}"
    project = var.project_name
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets_cidr)

  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.public_subnets_cidr[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name =  "${var.project_name}-public-subnet-${count.index}"            #"${var.project_name}-public-${count.index}"
    project = var.project_name
  }
}

# Elastic IP
resource "aws_eip" "nat_gw" {
  count  = length(var.public_subnets_cidr) > 0 && var.nat_gw_enabled ? 1 : 0
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
    project = var.project_name
  }
}

# Gateway
resource "aws_internet_gateway" "default" {
  count  = length(var.public_subnets_cidr) > 0 ? 1 : 0
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.project_name}-igw"
    project = var.project_name
  }
}

resource "aws_nat_gateway" "default" {
  count         = length(var.public_subnets_cidr) > 0 && var.nat_gw_enabled ? 1 : 0
  allocation_id = aws_eip.nat_gw[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.project_name}-nat-gw"
    project = var.project_name
  }
}

# Route Tables
resource "aws_route_table" "public" {
  count  = length(var.public_subnets_cidr)
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.project_name}-public-route-table-${count.index}"
    project = var.project_name
  }
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnets_cidr)
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.project_name}-private-route-table-${count.index}"
    project = var.project_name
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets_cidr)

  # subnet_id      = element(aws_subnet.private.*.id, count.index)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets_cidr)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route" "nat_gateway" {
  count = length(var.public_subnets_cidr) > 0 && var.nat_gw_enabled ? length(var.private_subnets_cidr) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.default[0].id
}

resource "aws_route" "internet_gateway" {
  count = length(var.public_subnets_cidr) > 0 ? length(var.public_subnets_cidr) : 0

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default[count.index].id
}

#Security Group
resource "aws_security_group" "default-sg" {
  name   = "${var.project_name}-sg"
  vpc_id = aws_vpc.default.id
  tags = {
    project = var.project_name
  }
}
