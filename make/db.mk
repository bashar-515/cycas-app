.PHONY: db-up db-down db-clean setup-db

CONTAINER_NAME := cycas-db
IMAGE_NAME := postgres

db-up: setup-db
	@if podman container exists $(CONTAINER_NAME); then \
		podman start $(CONTAINER_NAME); \
	else \
		podman run \
			--name  $(CONTAINER_NAME) \
			--env POSTGRES_PASSWORD=mysecretpassword \
			--publish 5433:5432 \
			--detach \
			$(IMAGE_NAME); \
	fi

db-down:
	podman stop --ignore $(CONTAINER_NAME)

db-clean:
	podman rm --ignore $(CONTAINER_NAME)

setup-db:
	podman pull $(IMAGE_NAME)
