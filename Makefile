include make/gen.mk
include make/auth.mk

.PHONY: dev setup

dev: auth-up
	npm run dev

setup:
	npm install
