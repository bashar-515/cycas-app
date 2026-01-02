.PHONY: web-up setup-web

web-up: setup-web
	npm run dev

setup-web:
	pnpm install
