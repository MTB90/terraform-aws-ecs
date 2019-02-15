# Simple web site on AWS.

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

### Setup web site photorec

1) Create on AWS:
	- certificate for your domain name
	- EC2 key
	- ECR repository named photorec

2) Update file envfile with your variables: AWS_PROFILE, AWS_ACCOUNT_ID, REGION

3) Update file terraform/main.tf for tfstate location

4) Update file terraform/variables.tf: 
	- bastion_sq_inbaound_rule: with your ip e.g 190.32.43.2/32
	- bastion_key_name: name of ec2 key
	- domain: your domain name for which you request certificate
	- certificate_arn: provide cert arn
	- cname_records: CNAME record to the DNS configuration for your domain

5) Setup resources: 
- push docker image to ECR
```bash 
$ make push-dev
``` 

- create AWS infrastructure:
```bash
cd terrraform
source ../envile
terraform apply
```
