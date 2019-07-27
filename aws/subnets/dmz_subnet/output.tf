# =================================
# Module Outputs
# =================================

output "dmz_subnet_id" {
  value = "${aws_subnet.subnet_dmz.id}"
}
