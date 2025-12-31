include make/auth.mk
include make/gen.mk
include make/web.mk

.PHONY: up

up: auth-up web-up

down: auth-down
