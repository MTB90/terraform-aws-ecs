# Local variables
locals {
  log_group = format("%s-log", var.tags["Name"])

  paramaters = map(
    "name", var.tags["Name"],
    "cpu_unit", var.cpu_unit,
    "memory", var.memory,
    "docker_image_uri", var.docker_image_uri,
    "workdir", var.workdir,
    "timeout", var.timeout,
    "interval", var.interval,
    "start_period", var.start_period,
    "retries", var.retries,
    "log_group", local.log_group
  )
}

# Resources
resource "aws_ecs_task_definition" "task_definition" {
  family       = var.tags["Name"]
  tags         = var.tags

  network_mode          = "bridge"
  container_definitions = templatefile(var.container_definition_file, merge(var.environments, local.paramaters))
}

resource "aws_cloudwatch_log_group" "container_log_group" {
  name = local.log_group
  tags = merge(var.tags, map("Name", local.log_group))
}
