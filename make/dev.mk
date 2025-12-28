.PHONY: up-dev

up-dev:
	docker run --interactive \
		--tty \
		--rm \
    --workdir /app \
    --env air_wd=/app \
    --volume $(PWD):/app \
    --publish 8000:8000 \
    cosmtrek/air \
    -c .air.toml
