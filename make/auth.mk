.PHONY: up-auth down-auth clean-auth

up-auth:
	docker compose \
		--file etc/docker/docker-compose.yaml \
		up \
		--detach \
		--wait

down-auth:
	docker compose \
		--file etc/docker/docker-compose.yaml \
		down \
		--remove-orphans

clean-auth:
	docker compose \
		--file etc/docker/docker-compose.yaml \
		down \
		--remove-orphans \
		--volumes
