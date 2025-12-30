include make/gen.mk
include make/auth.mk

.PHONY: dev

dev: auth-up
	npm run dev
