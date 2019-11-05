# Local variables
locals {
  name      = var.tags["Name"]
  log_group = format("%s/%s/%s/tasks", var.tags["Name"], var.tags["Environment"], var.tags["Project"])

  paramaters = map(
    "name", local.name,
    "region", var.region,
    "cpu_unit", var.cpu_unit,
    "memory", var.memory,
    "docker_image_uri", var.docker_image_uri,
    "workdir", var.workdir,
    "timeout", var.timeout,
    "interval", var.interval,
    "start_period", var.start_period,
    "retries", var.retries
  )
}

# Resources
resource "aws_ecs_task_definition" "task_definition" {
  family       = local.name
  tags         = var.tags

  network_mode          = "bridge"
  container_definitions = templatefile(var.container_definition_file, merge(var.environments, local.paramaters))
}

resource "aws_cloudwatch_log_group" "container_log_group" {
  name = local.log_group
  tags = merge(var.tags, map("Name", format("%s-cloudwatch-log-group", var.tags["Name"])))
}
