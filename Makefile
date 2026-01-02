include make/auth.mk
include make/backend.mk
include make/web.mk

.PHONY: up

up: auth-up web-up

down: auth-down
