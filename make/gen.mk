.PHONY: gen gen-server gen-models setup-gen tidy

GEN := go tool oapi-codegen

SPEC := api/spec/openapi.yaml
CFG_DIR := api/config/go

gen: gen-models gen-server gen-spec tidy

gen-models: setup-gen
	$(GEN) -config $(CFG_DIR)/models.yaml $(SPEC)

gen-server: setup-gen
	$(GEN) -config $(CFG_DIR)/server.yaml $(SPEC)

gen-spec: setup-gen
	$(GEN) -config $(CFG_DIR)/spec.yaml $(SPEC)

setup-gen: tidy

tidy:
	go mod tidy
