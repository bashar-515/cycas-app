.PHONY: up down

up: up-auth up-db
	$(MAKE) -j up-backend up-web

down: down-db down-auth

.PHONY: up-auth down-auth clean-auth

AUTH := podman compose
COMPOSE_FILE := etc/docker/docker-compose.yaml

up-auth:
	$(AUTH) \
		--file $(COMPOSE_FILE) \
		up \
		--detach \
		--wait

down-auth:
	$(AUTH) \
		--file $(COMPOSE_FILE) \
		down \
		--remove-orphans

clean-auth:
	$(AUTH) \
		--file $(COMPOSE_FILE) \
		down \
		--remove-orphans \
		--volumes

.PHONY: up-db down-db clean-db migrate setup-db wait

CONTAINER_NAME := cycas-db
DATABASE_USER := postgres
DATABASE_URL := postgres://$(DATABASE_USER):mysecretpassword@localhost:5433/postgres?sslmode=disable

up-db: setup-db migrate
	
down-db:
	podman stop --ignore $(CONTAINER_NAME)

clean-db:
	podman rm --ignore $(CONTAINER_NAME)

migrate: setup-db wait
	CYCAS_DATABASE_URL=$(DATABASE_URL) \
		go run ./cmd/migrate

setup-db:
	@if podman container exists $(CONTAINER_NAME); then \
		podman start $(CONTAINER_NAME); \
	else \
		podman run \
			--name  $(CONTAINER_NAME) \
			--env POSTGRES_PASSWORD=mysecretpassword \
			--publish 5433:5432 \
			--detach \
			postgres; \
	fi

wait:
	@for _ in 1 2 3 4 5 6 7 8 9; do \
		podman exec $(CONTAINER_NAME) pg_isready -U $(DATABASE_USER) >/dev/null 2>&1 && exit 0; \
		sleep 1; \
	done; \
	exit 1

.PHONY: up-backend gen-app download tidy

CFGS := models server spec

up-backend: gen-app tidy
	CYCAS_DATABASE_URL=postgres://app:mysecretpassword@localhost:5433/postgres?sslmode=disable \
		go tool air

gen-app: download
	$(foreach cfg,$(CFGS),go tool oapi-codegen -config api/config/server/$(cfg).yaml api/spec/openapi.yaml;)

download:
	go mod download

tidy:
	go mod tidy

.PHONY: up-web

up-web: install
	npm run dev

.PHONY: gen-sdk

gen-sdk: install
	openapi-generator generate \
		--generator-name typescript \
		--output gen/sdk \
		--input-spec api/spec/openapi.yaml

.PHONY: install

install:
	pnpm install
