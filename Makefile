include make/backend.mk
include make/web.mk

.PHONY: up down

up: up-auth up-db
	$(MAKE) -j up-backend up-web

down: db-down auth-down

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

.PHONY: up-db down-db clean-db

CONTAINER_NAME := cycas-db
IMAGE_NAME := postgres

up-db: db-setup db-provision db-migrate	
	
down-db:
	podman stop --ignore $(CONTAINER_NAME)

clean-db:
	podman rm --ignore $(CONTAINER_NAME)

.PHONY: db-migrate db-provision

DATABASE_URL := postgres://postgres:mysecretpassword@localhost:5433/postgres?sslmode=disable

db-migrate: db-provision
	CYCAS_DATABASE_URL='$(DATABASE_URL)' \
		go run ./cmd/migrate

db-provision: db-setup
	psql "$(DATABASE_URL)" -v ON_ERRORS_STOP=1 -f db/provision.sql

db-setup:
	@if podman container exists $(CONTAINER_NAME); then \
		podman start $(CONTAINER_NAME); \
	else \
		podman run \
			--name  $(CONTAINER_NAME) \
			--env POSTGRES_PASSWORD=mysecretpassword \
			--publish 5433:5432 \
			--detach \
			$(IMAGE_NAME); \
	fi

.PHONY: up-backend

up-backend: setup-backend
	CYCAS_DATABASE_URL=postgres://app:mysecretpassword@localhost:5433/postgres?sslmode=disable \
		go tool air

.PHONY: setup-backend

setup-backend: gen-app tidy

.PHONY: gen-app gen-server gen-models

GEN := go tool oapi-codegen

SPEC_FILE := api/spec/openapi.yaml
CFG_DIR := api/config/server

gen-app: gen-models gen-server gen-spec tidy

gen-models: setup-gen
	$(GEN) -config $(CFG_DIR)/models.yaml $(SPEC_FILE)

gen-server: setup-gen
	$(GEN) -config $(CFG_DIR)/server.yaml $(SPEC_FILE)

gen-spec: setup-gen
	$(GEN) -config $(CFG_DIR)/spec.yaml $(SPEC_FILE)

.PHONY: setup-gen

setup-gen: tidy

.PHONY: tidy

tidy:
	go mod tidy

.PHONY: up-web

up-web: setup-web
	npm run dev

.PHONY: setup-web

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
