include make/gen.mk

.PHONY: up

up:
	docker run --interactive \
		--tty \
		--rm \
    	--workdir /app \
    	--env air_wd=/app \
    	--volume $(PWD):/app \
    	--publish 8000:8000 \
    	cosmtrek/air \
    	-c .air.toml

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


