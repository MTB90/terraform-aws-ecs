# Local variables
locals {
  name      = var.tags["Name"]
  log_group = format("%s/container/awslog", var.tags["Project"])
}

# Resources
resource "aws_ecs_task_definition" "task_definition" {
  family       = local.name
  network_mode = "bridge"

  container_definitions = <<DEF
[
  {
    "name": "${local.name}",
    "image": "${var.docker_image_uri}",
    "cpu": ${var.cpu_unit},
    "memory": ${var.memory},
    "memoryReservation": ${var.memory},
    "entryPoint": [
      "python"
    ],
    "command": [
      "run.py"
    ],
    "environment": [
      {
        "name": "REGION",
        "value": "${var.region}"
      },
      {
        "name": "AUTH_URL",
        "value": "${var.auth_url}"
      },
      {
        "name": "AUTH_JWKS_URL",
        "value": "${var.auth_jwks_url}"
      },
      {
        "name": "AUTH_CLIENT_ID",
        "value": "${var.auth_client_id}"
      },
      {
        "name": "AUTH_CLIENT_SECRET",
        "value": "${var.auth_client_secret}"
      },
      {
        "name": "BASE_URL",
        "value": "${var.url}"
      },
      {
        "name": "SECRET_KEY",
        "value": "${random_string.secret_key.result}"
      },
      {
        "name": "DATABASE",
        "value": "${var.database}"
      },
      {
        "name": "STORAGE",
        "value": "${var.file_storage}"
      }
    ],
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": 8080
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${local.log_group}",
        "awslogs-region": "${var.region}"
      }
    },
    "workingDirectory": "${var.workdir}",
    "healthCheck": {
      "retries": ${var.retries},
      "command": [
        "CMD-SHELL",
        "curl -f http://localhost:8080/health || exit 1"
      ],
      "timeout": ${var.timeout},
      "interval": ${var.interval},
      "startPeriod": ${var.start_period}
    }
  }
]
DEF
}

resource "random_string" "secret_key" {
  length  = 16
  special = true
}

resource "aws_cloudwatch_log_group" "container_log_group" {
  name = local.log_group
  tags = merge(var.tags, map("Name", format("%s-cloudwatch-log-group", var.tags["Name"])))
}
