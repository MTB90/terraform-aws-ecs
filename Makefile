.EXPORT_ALL_VARIABLES:
include envfile

############### CONSTS ##############
PYTHON_SCRIPT=test
GREEN=\033[0;32m
RED=\033[0;31m
NC=\033[0m

export PYTHONPATH=${CURDIR}:${CURDIR}/photorec/

usage:
	@echo "$(GREEN)Usage (commands list):$(NC)"
	@echo "make aws-push-image (Push image to AWS ECR)"
	@echo "make aws-update-service (Update service on AWS)"
	@echo "make aws-tf-create (Create infrastructure on AWS)"
	@echo "make aws-tf-destroy (Destroy infrastructure on AWS)"
	@echo "make test (Run tests)"
	@echo "make pipenv-install (Create production python venv)"
	@echo "make pipenv-install-test (Create test python venv)"
	@echo "make docker-build (Build docker image)"

aws-push-image: docker-build _docker-tag _aws-login
	@echo "$(GREEN)Push image to AWS ECR$(NC)"
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/photorec:prod

aws-update-service:
	@echo "$(GREEN)Update ECS Service on AWS$(NC)"
	aws ecs update-service --cluster photorec-ecs-cluster-cluster --service photorec-ecs-service --force-new-deployment

_aws-login:
	@echo "$(GREEN)Login to AWS ECR$(NC)"
	$(eval AWS_LOGIN_COMMAND=$(shell aws ecr get-login --no-include-email))
	$(AWS_LOGIN_COMMAND)

aws-tf-create:
	@echo "$(GREEN)Create AWS infrastructure$(NC)"
	cd terraform; \
		terraform init; \
		terraform apply

aws-tf-destroy:
	@echo "$(GREEN)Clean AWS infrastructure$(NC)"
	cd terraform; \
		terraform init; \
		terraform destroy

pipenv-install:
	@echo "$(GREEN)Create virutalenv and install packages$(NC)"
	@cd photorec; \
		pipenv --rm;\
		pipenv install

pipenv-install-test:
	@echo "$(GREEN)Create dev virutalenv and install packages$(NC)"
	@cd photorec; \
		pipenv --rm;\
		pipenv install --dev\

docker-build:
	@echo "$(GREEN)Build docker image$(NC)"
	$(eval IMAGES=$(shell docker images -a | grep -e photorec.*prod | awk '{print $$3}'))
	@if [ -z "$(IMAGES)" ]; then echo "No image to delete"; else docker rmi $(IMAGES) --force; fi

	cd docker; \
		docker-compose -f docker-compose.yml build --no-cache

_docker-tag:
	@echo "$(GREEN)TAG docker image$(NC)"
	- docker rmi $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/photorec:prod
	docker tag photorec:prod $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/photorec:prod

travis:
	@echo "$(GREEN)Setup travis env$(NC)"
	pip install pipenv
	@cd photorec; \
		pipenv install --dev --system

test:
	@echo "$(GREEN)Running unittests$(NC)"
	@cd photorec; \
		pytest ../tests || exit 1

code-style:
	@echo "$(GREEN)Running FLAKE8$(NC)"
	flake8
