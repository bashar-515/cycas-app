# Cycas App

## Local Development
### First Run
1. Run `make auth-up` to set up the authentication service.
2. Navigate to the Zitadel console at [http://localhost:8080/ui/console?login_hint=zitadel-admin@zitadel.localhost]
(http://localhost:8080/ui/console?login_hint=zitadel-admin@zitadel.localhost), and use the password "Password1!" to log in; then, create a
["User Agent"](https://zitadel.com/docs/guides/manage/console/applications#user-agent) application.
3. Copy the application values listed in the '.env.development.template' file into a new '.env.development' file at the root.

### `make dev`
1. Start the local environment by running `make dev`.
2. ^C alone does not kill the entirely "undo" `make dev`. `make dev` starts the Vite development server in the foreground and a few
containers--for authentication--in the background. Kill these containers using `make auth-down`.

## TODO
1. Add Playwright tests.
2. Add unit and component Vitest tests.
