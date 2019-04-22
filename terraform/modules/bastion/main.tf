# Local variables
locals {
  module = "bastion"
  name   = "${format("%s-%s", var.tags["Project"], var.tags["Envarioment"])}"
  tags   = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

# Resources
resource "aws_instance" "bastion_ec2" {
  tags = "${local.tags}"

  ami                         = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  vpc_security_group_ids      = ["${aws_security_group.bastion_sg.id}"]
  associate_public_ip_address = true

  key_name = "${var.key_name}"
}

resource "aws_security_group" "bastion_sg" {
  name = "${format("%s-sg", local.name)}"
  tags = "${merge(var.tags, map("Name", format("%s-sg", local.name)))}"

  vpc_id = "${var.vpc_id}"

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.sq_inbound_rule}"]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
