.EXPORT_ALL_VARIABLES:

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
	@echo "make test (Run tests)"
	@echo "make pipenv-install (Create production python venv)"
	@echo "make pipenv-install-test (Create test python venv)"
	@echo "make docker-build (Build docker image)"

aws-push-image: docker-build _docker-tag _aws-login
	@echo "$(GREEN)Push image to AWS ECR$(NC)"
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/photorec:latest

aws-update-service:
	@echo "$(GREEN)Update ECS Service on AWS$(NC)"
	aws ecs update-service --cluster photorec-ecs-cluster-cluster --service photorec-ecs-service --force-new-deployment

_aws-login:
	@echo "$(GREEN)Login to AWS ECR$(NC)"
	$(eval AWS_LOGIN_COMMAND=$(shell aws ecr get-login --no-include-email))
	$(AWS_LOGIN_COMMAND)

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
	$(eval IMAGES=$(shell docker images -a | grep -e photorec.*latest | awk '{print $$3}'))
	@if [ -z "$(IMAGES)" ]; then echo "No image to delete"; else docker rmi $(IMAGES) --force; fi

	cd docker; \
		docker-compose -f docker-compose.yml build --no-cache

_docker-tag:
	@echo "$(GREEN)TAG docker image$(NC)"
	- docker rmi $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/photorec:latest
	docker tag photorec:latest $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/photorec:latest

travis-env:
	@echo "$(GREEN)Setup travis env$(NC)"
	pip install codecov
	pip install pipenv
	@cd photorec; \
		pipenv install --dev --system

travis-aws:
	@echo "$(GREEN)Setup travis AWS$(NC)"
	pip install awscli

test:
	@echo "$(GREEN)Running unittests$(NC)"
	@cd photorec; \
		pytest ../tests --cov=./ --cov-report=xml || exit 1

code-style:
	@echo "$(GREEN)Running FLAKE8$(NC)"
	flake8 || exit 1
