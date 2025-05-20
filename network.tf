locals {
  total_public_subnet = 4

  public_subnet_cidrs = [
    "10.0.0.0/24",
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]

  total_private_subnet = 4

  private_subnet_cidrs = [
    "10.0.10.0/24",
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.13.0/24"
  ]
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "VPC Workshop SMKN 1 Jakarta"
    Environment = var.app_env
    Project     = var.project_name
  }
}

resource "aws_subnet" "public-subnets" {
  count = local.total_public_subnet

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = local.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "Public-Subnets-${count.index + 1} Workshop SMKN 1 Jakarta"
    Environment = var.app_env
    Project     = var.project_name
  }
}


resource "aws_subnet" "private-subnets" {
  count = local.total_private_subnet

  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = local.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "private-Subnets-${count.index + 1} Workshop SMKN 1 Jakarta"
    Environment = var.app_env
    Project     = var.project_name
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name        = "IGW Workshop SMKN 1 Jakarta"
    Environment = var.app_env
    Project     = var.project_name
  }
}

# reservasi public IP (elastic IP) untuk NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name        = "NAT EIP Workshop SMKN 1 Jakarta"
    Environment = var.app_env
    Project     = var.project_name
  }
}

# buat NAT Gateway di public subnet pertama
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-subnets[0].id

  tags = {
    Name        = "NAT Gateway Workshop SMKN 1 Jakarta"
    Environment = var.app_env
    Project     = var.project_name
  }

  # Memastikan agar terraform membuat Elastic IP dulu, kemudian baru NAT Gateway
  depends_on = [aws_internet_gateway.igw]
}


# Buat public route table dan hubungkan Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "Public-RT Workshop SMKN 1 Jakarta"
    Environment = var.app_env
    Project     = var.project_name
  }
}

# Buat private route table dan hubungkan NAT gateway
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name        = "Private-RT Workshop SMKN 1 Jakarta"
    Environment = var.app_env
    Project     = var.project_name
  }
}

# Hubungkan semua public subnet ke public-RT
resource "aws_route_table_association" "public_subnets_association" {
  count = local.total_public_subnet

  subnet_id      = aws_subnet.public-subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Hubungkan semua private subnet ke private-RT
resource "aws_route_table_association" "private_subnet_association" {
  count = local.total_private_subnet

  subnet_id      = aws_subnet.private-subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
