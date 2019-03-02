include envfile

############### CONSTS ##############
PYTHON_SCRIPT=test
GREEN=\033[0;32m
RED=\033[0;31m
NC=\033[0m

export PYTHONPATH=${CURDIR}/photorec/

usage:
	@echo "$(GREEN)Usage (commands list):$(NC)"
	@echo "make ecr-push-image (Push image to AWS ECR)"
	@echo "make ecs-update-service (Update service on AWS)"
	@echo "make tf-create (Create infrastructure on AWS)"
	@echo "make tf-destroy (Destroy infrastructure on AWS)"
	@echo "make test-run (Run unittests)"

ecr-push-image: test-run _docker-build-image _docker-tag-image _aws-login
	@echo "$(GREEN)Push image to AWS ECR$(NC)"
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/photorec:dev

ecs-update-service:
	@echo "$(GREEN)Update ECS Service on AWS$(NC)"
	aws ecs update-service --cluster photorec-ecs-cluster-cluster --service photorec-ecs-service --force-new-deployment

tf-create:
	@echo "$(GREEN)Create AWS infrastructure$(NC)"
	cd terraform; \
		terraform init; \
		terraform apply

tf-destroy:
	@echo "$(GREEN)Clean AWS infrastructure$(NC)"
	cd terraform; \
		terraform destroy

test-run:
	@echo "$(GREEN)Running unittests$(NC)"
	@cd photorec; \
		pipenv install --dev;\
		pipenv run pytest ../tests || exit 1

_docker-tag-image:
	@echo "$(GREEN)TAG docker image$(NC)"
	- docker rmi $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/photorec:dev
	docker tag photorec:dev $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/photorec:dev

_docker-build-image:
	@echo "$(GREEN)Build docker image$(NC)"
	$(eval IMAGES=$(shell docker images -a | grep -e photorec.*dev | awk '{print $$3}'))
	@if [ -z "$(IMAGES)" ]; then echo "No image to delete"; else docker rmi $(IMAGES) --force; fi

	cd docker; \
		docker-compose -f docker-compose-dev.yml build --no-cache

_aws-login:
	@echo "$(GREEN)Login to AWS ECR$(NC)"
	$(eval AWS_LOGIN_COMMAND=$(shell aws ecr get-login --no-include-email))
	$(AWS_LOGIN_COMMAND)
