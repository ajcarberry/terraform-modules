# =================================
# Route Table
# =================================
# Route table for DMZ Subnet
# =================================
resource "aws_route_table" "route_dmz" {
  vpc_id = var.vpc

  tags = {
    Name = "route_dmz_${var.availability}_zone_${var.env}"
    Environment  = var.env
    VPC  = var.vpc_name
    Automation = "terraform"
  }
}

resource "aws_route" "route_rule_dmz" {
  route_table_id = aws_route_table.route_dmz.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = var.internet_gw
}

# =================================
# Subnet
# =================================
# DMZ subnets.
# =================================
resource "aws_subnet" "subnet_dmz" {
  vpc_id                  = var.vpc
  cidr_block              = var.cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "dmz_${var.cidr}_${var.availability_zone}"
    Environment  = var.env
    VPC  = var.vpc_name
    Automation = "terraform"
    Extra = var.tag
  }
}

resource "aws_route_table_association" "route_assoc_dmz" {
  subnet_id      = aws_subnet.subnet_dmz.id
  route_table_id = aws_route_table.route_dmz.id
}
