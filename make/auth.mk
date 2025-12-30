.PHONY: auth-up auth-down auth-clean

auth-up:
	podman compose \
		--file etc/docker/docker-compose.yaml \
		up \
		--detach \
		--wait

auth-down:
	podman compose \
		--file etc/docker/docker-compose.yaml \
		down \
		--remove-orphans

auth-clean:
	podman compose \
		--file etc/docker/docker-compose.yaml \
		down \
		--remove-orphans \
		--volumes
