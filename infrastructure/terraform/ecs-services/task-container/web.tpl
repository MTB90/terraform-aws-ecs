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
      "run.py"
    ],
    "environment": [
      {
        "name": "REGION",
        "value": "${region}"
      },
      {
        "name": "AUTH_URL",
        "value": "${auth_url}"
      },
      {
        "name": "AUTH_JWKS_URL",
        "value": "${auth_jwks_url}"
      },
      {
        "name": "AUTH_CLIENT_ID",
        "value": "${auth_client_id}"
      },
      {
        "name": "AUTH_CLIENT_SECRET",
        "value": "${auth_client_secret}"
      },
      {
        "name": "BASE_URL",
        "value": "${url}"
      },
      {
        "name": "SECRET_KEY",
        "value": "${secret_key}"
      },
      {
        "name": "DATABASE",
        "value": "${database}"
      },
      {
        "name": "STORAGE",
        "value": "${file_storage}"
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