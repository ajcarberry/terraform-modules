# =================================
# VPC
# =================================
resource "aws_vpc" "vpc_default" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.name}_${var.env}"
    Environment  = "${var.env}"
    Automation = "terraform"
  }
}

# Gateway
# =================================
# Internet Gateway
# =================================
resource "aws_internet_gateway" "internet_gw_default" {
    vpc_id = "${aws_vpc.vpc_default.id}"

    tags = {
      Name = "${var.name}_internet_gw_${var.env}"
      Environment  = "${var.env}"
      VPC  = "${aws_vpc.vpc_default.tags.Name}"
      Automation = "terraform"
    }
}
