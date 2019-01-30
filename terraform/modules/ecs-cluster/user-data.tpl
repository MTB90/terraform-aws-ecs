#!/bin/bash

# Install awslogs and jq
sudo yum install -y awslogs

# Create new awslogs file
sudo echo "[general]
state_file = /var/lib/awslogs/agent-state

[/var/log/dmesg]
file = /var/log/dmesg
log_group_name = /var/log/dmesg
log_stream_name = ${cluster}/{instance_id}

[/var/log/messages]
file = /var/log/messages
log_group_name = /var/log/messages
log_stream_name = ${cluster}/{instance_id}
datetime_format = %b %d %H:%M:%S

[/var/log/ecs/ecs-init.log]
file = /var/log/ecs/ecs-init.log
log_group_name = /var/log/ecs/ecs-init.log
log_stream_name = ${cluster}/{instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/ecs-agent.log]
file = /var/log/ecs/ecs-agent.log.*
log_group_name = /var/log/ecs/ecs-agent.log
log_stream_name = ${cluster}/{instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ" > /etc/awslogs/awslogs.conf

sudo echo "[plugins]
cwlogs = cwlogs
[default]
region = ${region}" > /etc/awslogs/awscli.conf

instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
sudo sed -i -e "s/{instance_id}/$instance_id/g" /etc/awslogs/awslogs.conf

# Start AWS loging
sudo systemctl start awslogsd
sudo systemctl enable awslogsd.service

echo ECS_CLUSTER=${cluster} >> /etc/ecs/ecs.config;echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;