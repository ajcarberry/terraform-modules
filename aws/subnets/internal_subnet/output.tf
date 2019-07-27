# =================================
# Module Outputs
# =================================

output "internal_subnet_id" {
  value = "${aws_subnet.subnet_internal.id}"
}
