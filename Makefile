include make/gen.mk
include make/auth.mk

.PHONY: dev setup

dev: auth-up
	pnpm run dev --open

setup:
	npm install
