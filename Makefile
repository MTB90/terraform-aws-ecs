.EXPORT_ALL_VARIABLES:

############### CONSTS ##############
PYTHON_SCRIPT=test
GREEN=\033[0;32m
RED=\033[0;31m
NC=\033[0m

export PYTHONPATH=${CURDIR}:${CURDIR}/photorec/


########################### AWS DEPLOYMENT ECS ##########################
aws-push-image: app-docker-build _app-docker-tag _aws-login
	@echo "$(GREEN)Push image to AWS ECR$(NC)"
	docker push $(AWS_ECR_WEB):latest

aws-update-service:
	@echo "$(GREEN)Update ECS Service on AWS$(NC)"
	aws ecs update-service --region $(AWS_REGION) --cluster $(AWS_ECS_CLUSTER) --service $(AWS_ECS_SERVICE_WEB) --force-new-deployment

_app-docker-tag:
	@echo "$(GREEN)TAG docker image$(NC)"
	docker tag photorec:latest $(AWS_ECR_WEB):latest

_aws-login:
	@echo "$(GREEN)Login to AWS ECR$(NC)"
	$(eval AWS_LOGIN_COMMAND=$(shell aws ecr get-login --region $(AWS_REGION) --no-include-email))
	$(AWS_LOGIN_COMMAND)

app-docker-build:
	@echo "$(GREEN)Build app docker image$(NC)"
	$(eval IMAGES=$(shell docker images -a | grep -e photorec.*latest | awk '{print $$3}'))
	@if [ -z "$(IMAGES)" ]; then echo "No image to delete"; else docker rmi $(IMAGES) --force; fi

	cd devops; \
		docker-compose -f docker-compose.yml build --no-cache

########################### AWS DEPLOYMENT Lambda ##########################
aws-update-lambda: thumbnail-lambda rekognition-lambda
	@cd inrastructure/production/eu-west-1/prod/serverless; \
		terragrunt apply -auto-approve

thumbnail-lambda: _copy-source-package
	unzip serverless/pillow.zip -d serverless/src/
	cp serverless/lambda_handler/thumbnail.py serverless/src/
	cd serverless/src;\
		zip -r ../../serverless/thumbnail.zip .
	rm -r serverless/src

rekognition-lambda: _copy-source-package
	cp serverless/lambda_handler/rekognition.py serverless/src/
	cd serverless/src;\
		zip -r ../../serverless/rekognition.zip .
	rm -r serverless/src

_copy-source-package:
	mkdir -p serverless/src
	@cd photorec; \
		find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete
	cp -r photorec serverless/src


######################## PIPENV ENVIRONMENT ########################
pipenv-install:
	@echo "$(GREEN)Create virutalenv and install packages$(NC)"
	@cd services; \
		pipenv --rm;\
		pipenv install

pipenv-install-test:
	@echo "$(GREEN)Create dev virutalenv and install packages$(NC)"
	@cd services; \
		pipenv --rm;\
		pipenv install --dev\


######################## TRAVIS ENVIRONMENT ########################
travis-env:
	@echo "$(GREEN)Setup travis env$(NC)"
	pip install codecov
	pip install pipenv
	@cd services; \
		pipenv install --dev --system

travis-aws:
	@echo "$(GREEN)Setup travis AWS$(NC)"
	pip install awscli
	mkdir -p ~/.aws
	echo [default] > ~/.aws/credentials
	echo aws_access_key_id = ${AWS_ACCESS_KEY_ID} >> ~/.aws/credentials
	echo aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY} >> ~/.aws/credentials


############################## TESTING #############################
test: localstack-env
	@echo "$(GREEN)Running unittests$(NC)"

	@cd photorec; \
		pytest ../tests --cov=./ --cov-report=xml || exit 1

localstack-env:
	@echo "$(GREEN)Up localstack docker image$(NC)"

	$(eval CONTAINER=$(shell docker ps -a -q --filter="name=localstack"))
	@if [ -z "$(CONTAINER)" ]; then echo "No container to stop"; else docker stop $(CONTAINER); fi

	cd devops; \
		docker-compose -f docker-compose-local.yml up -d

	sleep 5

	@echo "$(GREEN)Create AWS infrastructure on localstack$(NC)"

	@cd infrastructure/localstack; \
		rm terraform.tfstate || true; \
		terraform init; \
		terraform apply -auto-approve

code-style:
	@echo "$(GREEN)Running FLAKE8$(NC)"
	flake8 || exit 1
