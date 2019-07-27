# Ubuntu EC2
# =================================
# DNS Suffix
# =================================
variable "dns_suffix" {
	description = "dns suffix per environment."
	default = {
		stage = "-stage"
		prod  = ""
	}
}

# AMI Identification
# =================================
data "aws_ami" "ubuntu" {

  most_recent = true
  owners = ["self"] #default profile

  filter {
    name   = "name"
    values = ["ubuntu-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Deployment
# =================================
resource "aws_instance" "ubuntu_ec2" {
  count                       = "${var.instance_count}"
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  vpc_security_group_ids      = ["${var.security_groups}"]
  associate_public_ip_address = "${var.public_ip}"
  tags {
    Name          = "${var.instance_count > 1 ? format("%s-%d", var.name, count.index+1) : var.name}"
    Environment   = "${var.env}"
    VPC           = "${var.vpc_name}"
    Automation    = "terraform"
    OS            = "ubuntu"
    Base_AMI_Name = "${data.aws_ami.ubuntu.name}"
  }

  provisioner "local-exec" {
    command = "${var.playbook == "" ? "sleep 60" : "sleep 90; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${self.public_ip}, ${var.playbook} --extra-vars 'env=${var.env}' --vault-password-file ../../ansible/vault_pass.txt"}"
  }
	provisioner "local-exec" {
		command = "${var.destroy == "" ? "sleep 10" : "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${self.public_ip}, ${var.destroy} --extra-vars 'env=${var.env}' --vault-password-file ../../ansible/vault_pass.txt"}"
		when = "destroy"
	}

  lifecycle {
    ignore_changes = ["ami"]
  }
}

# R53 DNS
# =================================
resource "aws_route53_record" "a_record" {
  count     = "${var.instance_count}"
  provider  = "aws.master"
  zone_id   = "ZSM8H062M1J3G"
  name      = "${var.instance_count > 1 ? format("%s-%d", "${var.name}${lookup(var.dns_suffix, var.env)}", count.index+1) : "${var.name}${lookup(var.dns_suffix, var.env)}"}"
  type      = "CNAME"
  ttl       = "300"
  records   = ["${element(aws_instance.ubuntu_ec2.*.public_dns, count.index)}"]
}
