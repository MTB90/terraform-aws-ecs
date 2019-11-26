[
  {
    "name": "${name}",
    "image": "${docker_image_uri}",
    "cpu": ${cpu_unit},
    "memory": ${memory},
    "memoryReservation": ${memory},
    "entryPoint": [
      "python"
    ],
    "command": [
      "app.py"
    ],
    "environment": [
      {
        "name": "REGION",
        "value": "${region}"
      },
      {
        "name": "PROJECT",
        "value": "${project}"
      },
      {
        "name": "SERVICE",
        "value": "${service}"
      },
      {
        "name": "ENVIRONMENT",
        "value": "${environment}"
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
        "awslogs-group": "${log_group}",
        "awslogs-region": "${region}"
      }
    },
    "workingDirectory": "${workdir}",
    "healthCheck": {
      "retries": ${retries},
      "command": [
        "CMD-SHELL",
        "curl -f http://localhost:8080/health || exit 1"
      ],
      "timeout": ${timeout},
      "interval": ${interval},
      "startPeriod": ${start_period}
    }
  }
]