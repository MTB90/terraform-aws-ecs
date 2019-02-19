include envfile

############### CONSTS ##############
PYTHON_SCRIPT=test
GREEN=\033[0;32m
RED=\033[0;31m
NC=\033[0m

export PYTHONPATH=${CURDIR}/photorec/

help:
	@echo -e "$(RED)############################# $(GREEN) Help (commands) $(RED)#############################$(NC)"
	@echo "make deploy-dev (Deploy DEV on AWS)"
	@echo "make push-dev (Push image to AWS ECR)"
	@echo "make update-dev-image (Update service on AWS)"
	@echo "make create-infra (Create infrastructure on AWS)"
	@echo "make destroy-infra (Destroy infrastructure on AWS)"
	@echo "make unittest (Run unittests)"

deploy-dev: push-dev-image create-infra
	@echo -e "$(RED)############################## $(GREEN)DEV environment is ready $(RED)##############################$(NC)"

push-dev-image: _unittest _build-image-dev _tag-dev _aws-login
	@echo -e "$(RED)############################# $(GREEN) Push DEV image to AWS ECR $(RED)#############################$(NC)"
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/photorec:dev

update-dev:
	@echo -e "$(RED)############################# $(GREEN) Update DEV Service on AWS $(RED)#############################$(NC)"
	aws ecs update-service --cluster photorec-ecs-cluster-cluster --service photorec-ecs-service --force-new-deployment

_build-image-dev:
	@echo -e "$(RED)############################# $(GREEN) Build DEV docker image $(RED)#############################$(NC)"
	$(eval IMAGES=$(shell docker images -a | grep -e photorec.*dev | awk '{print $$3}'))
	@if [ -z "$(IMAGES)" ]; then echo "No image to delete"; else docker rmi $(IMAGES) --force; fi

	cd docker; \
		docker-compose -f docker-compose-dev.yml build --no-cache

_tag-dev:
	@echo -e "$(RED)############################# $(GREEN) TAG DEV docker image $(RED)#############################$(NC)"
	- docker rmi $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/photorec:dev
	docker tag photorec:dev $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/photorec:dev

create-infra:
	@echo -e "$(RED)############################ $(GREEN)Create AWS infrastructure $(RED)############################$(NC)"
	cd terraform; \
		terraform init; \
		terraform apply

destroy-infra:
	@echo -e "$(RED)############################ $(GREEN)Clean AWS infrastructure $(RED)############################$(NC)"
	cd terraform; \
		terraform destroy

_aws-login:
	@echo -e "$(RED)############################# $(GREEN) Login to AWS ECR $(RED)#############################$(NC)"
	$(eval AWS_LOGIN_COMMAND=$(shell aws ecr get-login --no-include-email))
	$(AWS_LOGIN_COMMAND)

unittest:
	@echo -e "$(RED)############################# $(GREEN) Run unittests $(RED)#############################$(NC)"
	@cd photorec; \
		pipenv install --dev;\
		pipenv run pytest ../tests || exit 1

