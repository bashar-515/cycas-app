.PHONY: db-up db-down db-clean

CONTAINER_NAME := cycas-db
IMAGE_NAME := postgres

db-up:
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

.PHONY: migrate provision

DATABASE_URL := postgres://postgres:mysecretpassword@localhost:5433/postgres?sslmode=disable

migrate: provision
	CYCAS_DATABASE_URL='$(DATABASE_URL)' go run ./cmd/migrate

provision: 
	psql "$(DATABASE_URL)" -v ON_ERRORS_STOP=1 -f db/provision.sql
