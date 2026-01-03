.PHONY: web-up setup-web

web-up: setup-web
	npm run dev

setup-web: install

.PHONY: gen-sdk

gen-sdk: install
	openapi-generator generate \
		--generator-name typescript \
		--output gen/sdk \
		--input-spec api/spec/openapi.yaml \

.PHONY: install

install:
	pnpm install
