# =================================
# Module Outputs
# =================================

output "vpc_id" {
  value = "${aws_vpc.vpc_default.id}"
}

output "vpc_name" {
  value = "${aws_vpc.vpc_default.tags.Name}"
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.internet_gw_default.id}"
}
