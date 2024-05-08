#####################################################
# Makefile containing shortcut commands for project #
#####################################################
# Created By Enrique Plata

# MACOS USERS:
#  Make should be installed with XCode dev tools.
#  If not, run `xcode-select --install` in Terminal to install.

# WINDOWS USERS:
#  1. Install Chocolately package manager: https://chocolatey.org/
#  2. Open Command Prompt in administrator mode
#  3. Run `choco install make`
#  4. Restart all Git Bash/Terminal windows.

.DEFAULT_GOAL := help
include .env
export

.PHONY: docker-run-master
docker-run-master: ## Run docker container
	@ docker build -t prefect-docker .
	@ docker run --name prefect-worker -itd -e PREFECT_API_KEY=${PREFECT_API_KEY} -v $(PWD)/flows:/opt/prefect/flows prefect-docker

.PHONY: docker-rm-master
docker-rm-master: ## Remove docker container
	@ docker rm -f prefect-worker

.PHONY: docker-it-master
docker-it-master: ## Run docker container in interactive mode
	@ docker exec -it prefect-worker /bin/bash

help:
	@ echo "Please use \`make <target>' where <target> is one of"
	@ perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}'
