# check for prerequisites
EXECUTABLES = helm jq
K := $(foreach exec,$(EXECUTABLES),\
	$(if $(shell which $(exec)),"",$(error "$(exec) not in path")))

# fetch name and namespace
NAME = $(shell jq -r .name values.yaml)
NAMESPACE = $(shell jq -r .namespace values.yaml)

install:
	helm install --namespace=$(NAMESPACE) --name=$(NAME) .
delete:
	helm delete --purge $(NAME)
