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

.PHONY: docker-run
docker-run: ## Run docker container
	@ docker build -t prefect-docker .
	@ docker run --name prefect-worker -itd -e PREFECT_API_KEY=pnu_0YAZTwR33RmYzhzzlMnbN9MjIBJqsW01UlmR prefect-docker

.PHONY: docker-rm
docker-rm: ## Remove docker container
	@ docker rm -f prefect-worker

.PHONY: docker-it
docker-it: ## Run docker container in interactive mode
	@ docker exec -it prefect-worker /bin/bash

help:
	@ echo "Please use \`make <target>' where <target> is one of"
	@ perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}'
