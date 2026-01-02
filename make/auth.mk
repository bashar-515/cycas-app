.PHONY: auth-up auth-down auth-clean setup-auth

AUTH := podman compose
COMPOSE_FILE := etc/docker/docker-compose.yaml

auth-up: setup-auth
	$(AUTH) \
		--file $(COMPOSE_FILE) \
		up \
		--detach \
		--wait

auth-down:
	$(AUTH) \
		--file $(COMPOSE_FILE) \
		down \
		--remove-orphans

auth-clean:
	$(AUTH) \
		--file $(COMPOSE_FILE) \
		down \
		--remove-orphans \
		--volumes

setup-auth:
	$(AUTH) \
		--file $(COMPOSE_FILE) \
		pull
