# Simple web site on AWS.
[![Build Status](https://travis-ci.com/MTB90/terraform-aws-ecs.svg?branch=master)](https://travis-ci.com/MTB90/terraform-aws-ecs)
[![codecov.io](https://codecov.io/github/MTB90/terraform-aws-ecs/coverage.svg?branch=master)](https://codecov.io/github/MTB90/terraform-aws-ecs?branch=master)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

List of used AWS components:
- VPC, Subnets, Internet gateway
- Bastion, Nat-Instance
- Security groups
- EC2, ALB
- ROUTE53 zone
- ECS cluster, ECS service, ECS task definition, ECR
- App autoscaling target/policy (ECS task)
- Autoscaling group/policy (EC2)
- COGNITO
- Cloudwatch (logs EC2/Task)
- Dynamodb

### AWS infrastructure:

### Run locally unit-tests:
```bash
$ make test
```
### Manual deployment:
* Update file envfile with your variables
* Push image:
```bash
$ make aws-docker-image
$ make aws-push-image
``` 
