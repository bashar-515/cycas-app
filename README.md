# Cycas App

## Local Development

### Dependencies
1. Go: run server
2. Node+pnpm: run frontend
3. Podman: run authentication service and database
4. psql: run db/provision.sql against database
5. openapi-generator: generate SDK

### First Run
1. run `make auth-up` to set up the authentication service
2. navigate to the Zitadel console at `http://localhost:8080/ui/console?login_hint=zitadel-admin@zitadel.localhost`, and use the password
"Password1!" to log in; then, create a [_User Agent_](https://zitadel.com/docs/guides/manage/console/applications#user-agent) application.
Go through the initialization wizard; refer to `.env.example` when filling in redirect URI's and whatnot

4. replace the OIDC client ID found in `.env.example` with the client ID of your newly created Zitadel app. Copy the contents of
`.env.example` into a new `.env`

### `make up`
1. start the local environment by running `make up`
2. ^C alone does not kill or entirely "undo" `make up`. `make up` starts a database container and some authentication containers in the
background. In the foreground, it starts a development server to serve the frontend and launches the Go backend server. `make down` stops
all the containers started by `make up`

## TODO
1. after a user signs in, they are always redirected to the app's homepage (@ '/'). We should preserve the path they're trying to access
and redirect them there

2. add Playwright tests
3. add unit and component Vitest tests
4. add Go tests
