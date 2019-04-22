# Local variables
locals {
  module = "nat-instance"
  name   = "${format("%s-%s", var.tags["Project"], var.tags["Envarioment"])}"
  tags   = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

# Resources
resource "aws_instance" "nat_ec2" {
  tags = "${local.tags}"

  ami                         = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  vpc_security_group_ids      = ["${aws_security_group.nat_sg.id}"]
  associate_public_ip_address = true
  source_dest_check           = false
}

resource "aws_route" "nat_route" {
  route_table_id         = "${var.route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  instance_id            = "${aws_instance.nat_ec2.id}"
}

resource "aws_security_group" "nat_sg" {
  name = "${format("%s-sg", local.name)}"
  tags = "${merge(var.tags, map("Name", format("%s-sg", local.name)))}"

  vpc_id = "${var.vpc_id}"

  # Inbound HTTP
  ingress {
    protocol        = "TCP"
    from_port       = 80
    to_port         = 80
    security_groups = ["${var.sq_inbound_rule}"]
  }

  # Inbound HTTPS
  ingress {
    protocol        = "TCP"
    from_port       = 443
    to_port         = 443
    security_groups = ["${var.sq_inbound_rule}"]
  }

  # Outbound HTTP
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound HTTPS
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
