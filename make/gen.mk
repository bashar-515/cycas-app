.PHONY: gen gen-server gen-models setup-gen

gen: gen-models gen-server gen-spec

gen-models: gen-setup
	go tool oapi-codegen -config api/config/go-models-cfg.yaml api/spec/openapi.yaml && \
		go mod tidy

gen-server: gen-setup
	go tool oapi-codegen -config api/config/go-server-cfg.yaml api/spec/openapi.yaml && \
		go mod tidy

gen-spec: gen-setup
	go tool oapi-codegen -config api/config/go/go-spec-cfg.yaml api/spec/openapi.yaml && \
		go mod tidy

setup-gen:
	go mod tidy
