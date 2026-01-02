.PHONY: db-up db-down db-clean

CONTAINER_NAME := cycas-db

db-up:
	@if podman container exists $(CONTAINER_NAME); then \
		podman start $(CONTAINER_NAME); \
	else \
		podman run \
			--name  $(CONTAINER_NAME) \
			--env POSTGRES_PASSWORD=mysecretpassword \
			--publish 5433:5432 \
			--detach \
			postgres; \
	fi

db-down:
	podman stop --ignore $(CONTAINER_NAME)

db-clean:
	podman rm --ignore $(CONTAINER_NAME)
