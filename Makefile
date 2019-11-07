USER = carlos
USER_HOME = /home/$(USER)
SSH_DIR = $(USER_HOME)/.ssh

.PHONY: help
help: ## Prints targets and a help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build:
	@docker image build --tag=workspace .

.PHONY: run
run:
	@docker container run -dit --volume=mind-booster:$(USER_HOME)/work/ --rm --volume=id_rsa_wcp:$(SSH_DIR)/ --name workspace-run

# docker container run -dit --volume=mind-booster:/home/carlos/work/ --rm --volume=id_rsa_wcp:$/home/carlos/.ssh/ --name workspace-run
