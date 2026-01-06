.PHONY: backend-up setup-backend

DATABASE_URL := postgres://app:mysecretpassword@localhost:5433/postgres?sslmode=disable

backend-up: setup-backend
	CYCAS_DATABASE_URL='$(DATABASE_URL)' go tool air

setup-backend: gen-app tidy

.PHONY: gen-app gen-server gen-models setup-gen

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

setup-gen: tidy

.PHONY: tidy

tidy:
	go mod tidy
