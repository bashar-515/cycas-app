include make/auth.mk
include make/backend.mk
include make/web.mk

.PHONY: up

up: auth-up
	$(MAKE) -j web-up backend-up

down: auth-down
