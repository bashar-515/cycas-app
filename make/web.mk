.PHONY: web-up setup-web

web-up: setup-web
	pnpm run dev --open

setup-web:
	pnpm install
