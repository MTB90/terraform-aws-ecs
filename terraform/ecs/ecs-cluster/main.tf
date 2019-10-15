# Resources
resource "aws_ecs_cluster" "cluster" {
  name = var.tags["Name"]
  tags = var.tags
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.tpl")

  vars = {
    cluster = aws_ecs_cluster.cluster.name
    region  = var.region
    prefix  = format("%s/ec2", var.tags["Project"])
  }
}
