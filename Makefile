include make/auth.mk
include make/backend.mk
include make/db.mk
include make/web.mk

.PHONY: up down

up: auth-up db-up
	$(MAKE) -j backend-up web-up

down: db-down auth-down
