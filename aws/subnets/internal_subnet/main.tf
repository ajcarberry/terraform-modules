# Route Tables
# =================================
# Default route table
# =================================
resource "aws_route_table" "route_internal" {
  vpc_id = "${var.vpc}"

  tags = {
    Name = "route_internal_${var.availability_zone}_${var.env}"
    Environment  = "${var.env}"
    VPC  = "${var.vpc_name}"
    Automation = "terraform"
  }
}

# Subnet
# =================================
# internal subnet
# =================================
resource "aws_subnet" "subnet_internal" {
  vpc_id                  = "${var.vpc}"
  cidr_block              = "${var.cidr}"
  availability_zone       = "${var.availability_zone}"
  map_public_ip_on_launch = false

  tags = {
    Name = "internal_${var.cidr}_${var.availability_zone}"
    Environment  = "${var.env}"
    VPC  = "${var.vpc_name}"
    Automation = "terraform"
    Extra = "${var.tag}"
  }
}

resource "aws_route_table_association" "route_assoc_mgmt" {
  subnet_id      = "${aws_subnet.subnet_internal.id}"
  route_table_id = "${aws_route_table.route_internal.id}"
}
