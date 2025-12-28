.PHONY: gen gen-server gen-models setup-gen

gen: gen-models gen-server gen-spec

gen-models: setup-gen
	go tool oapi-codegen -config api/config/go/models.yaml api/spec/openapi.yaml && \
		go mod tidy

gen-server: setup-gen
	go tool oapi-codegen -config api/config/go/server.yaml api/spec/openapi.yaml && \
		go mod tidy

gen-spec: setup-gen
	go tool oapi-codegen -config api/config/go/spec.yaml api/spec/openapi.yaml && \
		go mod tidy

setup-gen:
	go mod tidy
