# =================================
# Gateway
# =================================
# NAT Gateway
# =================================
resource "aws_nat_gateway" "nat_gw" {
    subnet_id      = var.dmz_subnet
    allocation_id  = aws_eip.nat_gw.id
}

# =================================
# Elastic IP
# =================================
resource "aws_eip" "nat_gw" {
  vpc   = true
}

# =================================
# Route Table
# =================================
# Route table for default subnets
# =================================
resource "aws_route_table" "route_nat" {
  vpc_id = var.vpc

  tags = {
    Name = route_nat_var.availability_zone_var.env
    Environment  = var.env
    VPC  = var.vpc_name
    Automation = "terraform"
  }
}

resource "aws_route" "route_rule_nat" {
  route_table_id = aws_route_table.route_nat.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw.id
}

# =================================
# Subnet
# =================================
# default subnet
# =================================
resource "aws_subnet" "subnet_nat" {
  vpc_id                  = var.vpc
  cidr_block              = var.cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = nat_var.cidr_var.availability_zone
    Environment  = var.env
    VPC  = var.vpc_name
    Automation = "terraform"
    Extra = var.tag
  }
}

resource "aws_route_table_association" "route_assoc_nat" {
  subnet_id      = aws_subnet.subnet_nat.id
  route_table_id = aws_route_table.route_nat.id
}
