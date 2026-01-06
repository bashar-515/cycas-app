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

.PHONY: up-backend setup-backend

up-backend: setup-backend
	CYCAS_DATABASE_URL=postgres://app:mysecretpassword@localhost:5433/postgres?sslmode=disable \
		go tool air

setup-backend: gen-app tidy

.PHONY: gen-app gen-server gen-models gen-setup tidy

GEN := go tool oapi-codegen
SPEC_FILE := api/spec/openapi.yaml
CFG_DIR := api/config/server

gen-app: gen-models gen-server gen-spec tidy

gen-models: gen-setup
	$(GEN) -config $(CFG_DIR)/models.yaml $(SPEC_FILE)

gen-server: gen-setup
	$(GEN) -config $(CFG_DIR)/server.yaml $(SPEC_FILE)

gen-spec: gen-setup
	$(GEN) -config $(CFG_DIR)/spec.yaml $(SPEC_FILE)

gen-setup: 

tidy:
	go mod tidy

.PHONY: up-web setup-web

up-web: setup-web
	npm run dev

setup-web: install

.PHONY: gen-sdk

gen-sdk: install
	openapi-generator generate \
		--generator-name typescript \
		--output gen/sdk \
		--input-spec api/spec/openapi.yaml

.PHONY: install

install:
	pnpm install
