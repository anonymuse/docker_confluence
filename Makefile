BUILD=build/package
CONFLUENCE_IMAGE_NAME=confluence
CONFLUENCE_VERSION=latest
CONFLUENCE_PORT="8090:8090"

help:
	@echo "---"
	@echo "confluence-build - Build container for deployment."
	@echo "---"
	@echo "confluence_standalone - Run single container for local development."
	@echo "---"
	@echo "confluence_stack - Run Docker Compose stack for local development."
	@echo "---"
	@echo "confluence_debug - Run container interactively for debugging."
	@echo "---"
	@echo "confluence_deploy - Publish container to Registry. Note, you must be\
	 logged in.\\n""Ensure that your NAMESPACE variable has a trailing /"
	@echo "---"
	@echo "confluence_cleanup - Remove local confluence container images."
	@echo "---"

confluence_build:
	@docker build -t $(NAMESPACE)$(CONFLUENCE_IMAGE_NAME):$(CONFLUENCE_VERSION) .

confluence_standalone:
	@docker run --rm --name confluence_standalone --publish $(CONFLUENCE_PORT) $(NAMESPACE)$(CONFLUENCE_IMAGE_NAME):$(CONFLUENCE_VERSION)

confluence_stack:
	@docker-compose up

confluence_debug:
	@docker run --rm --name confluence_debug -it $(NAMESPACE)$(CONFLUENCE_IMAGE_NAME):$(CONFLUENCE_VERSION) /bin/bash

confluence_deploy:
	@docker push $(NAMESPACE)/$(CONFLUENCE_IMAGE_NAME):$(CONFLUENCE_VERSION)

#TODO: cleanup environment
confluence_cleanup:
	#@ docker stop $ && docker rm && docker rmi

#TODO: build container against specific revision
#confluence_build_v2:
	#@cp $(CONFLUENCE_APP)/packaging/docker/Dockefile Dockerfile
	#@sed -i s/DYNAMIC_VARIABLE/"$(DYNAMIC)"/g Dockerfile
	#@ docker build --force-rm=true --rm=true --no-cache -t=$(CONFLUENCE_IMAGE_NAME):$(CONFLUENCE_VERSION) .
	#@rm Dockerfile


