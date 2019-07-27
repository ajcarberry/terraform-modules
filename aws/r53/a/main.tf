resource "aws_route53_record" "a_record" {
  provider  = "aws.master"
  zone_id   = "ZSM8H062M1J3G"
  name      = "${var.name}"
  type      = "A"
  ttl       = "300"
  records   = ["${var.records}"]
}
