# Local variables
locals {
  module = "ecs-task-definition"
  name   = "${format("%s-%s", var.tags["Project"] ,local.module)}"
  tags   = "${merge(var.tags, map("Module", local.module))}"
}

resource "aws_ecs_task_definition" "task_definition" {
  family       = "${local.name}"
  network_mode = "awsvpc"

  container_definitions = <<DEF
[
  {
    "name": "${local.name}",
    "image": "${var.docker_image_uri}",
    "cpu": ${var.cpu_unit},
    "memory": ${var.memory},
    "memoryReservation": ${var.memory},
    "entryPoint": [
      "flask"
    ],
    "command": [
      "run", "--host=0.0.0.0"
    ],
    "environment": [
      {
        "name": "FLASK_APP",
        "value": "app"
      },
      {
        "name": "FLASK_RUN_PORT",
        "value": "80"
      }
    ],
    "portMappings": [
        {
        "hostPort": 80,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "workingDirectory": "${var.workdir}",
    "healthCheck": {
      "retries": ${var.retries},
      "command": [
        "CMD-SHELL",
        "curl -f http://localhost: || exit 1"
      ],
      "timeout": ${var.timeout},
      "interval": ${var.interval},
      "startPeriod": ${var.start_period}
    }
  }
]
DEF
}
