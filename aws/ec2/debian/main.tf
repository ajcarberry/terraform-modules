# Debian EC2
# =================================
# AMI Identification
# =================================
data "aws_ami" "debian" {

  most_recent = true
  owners = ["self"]

  filter {
    name   = "name"
    values = ["debian-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Deployment
# =================================
resource "aws_instance" "debian_ec2" {
  count                       = "${var.instance_count}"
  ami                         = "${data.aws_ami.debian.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  vpc_security_group_ids      = ["${var.security_groups}"]
  associate_public_ip_address = "${var.public_ip}"
  tags = {
    Name          = "${var.instance_count > 1 ? format("%s-%d", var.name, count.index+1) : var.name}"
    Environment   = "${var.env}"
    VPC           = "${var.vpc_name}"
    Automation    = "terraform"
    OS            = "debian"
    Base_AMI_Name = "${data.aws_ami.debian.name}"
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
