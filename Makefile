include envfile

############### CONSTS ##############
PYTHON_SCRIPT=test
GREEN=\033[0;32m
RED=\033[0;31m
NC=\033[0m

push-dev: build-image-dev tag-dev aws-login
	@echo -e "$(RED)############################# $(GREEN) Push DEV image to AWS ECR $(RED)#############################$(NC)"
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/photorec:dev

build-image-dev:
	@echo -e "$(RED)############################# $(GREEN) Build docker image $(RED)#############################$(NC)"
	$(eval IMAGES=$(shell docker images -a | grep -e photorec.*dev | awk '{print $$3}'))
	@if [ -z "$(IMAGES)" ]; then echo "No image to delete"; else docker rmi $(IMAGES) --force; fi

	cd docker; \
		docker-compose -f docker-compose-dev.yml build --no-cache

aws-login:
	@echo -e "$(RED)############################# $(GREEN) Login to AWS ECR $(RED)#############################$(NC)"
	$(eval AWS_LOGIN_COMMAND=$(shell aws ecr get-login --no-include-email))
	$(AWS_LOGIN_COMMAND)

tag-dev: 
	@echo -e "$(RED)############################# $(GREEN) TAG docker image $(RED)#############################$(NC)"
	- docker rmi $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/photorec:dev
	docker tag photorec:dev $(AWS_ACCOUNT_ID).dkr.ecr.$(REGION).amazonaws.com/photorec:dev
