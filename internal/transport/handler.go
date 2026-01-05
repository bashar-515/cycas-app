package transport

import (
	"net/http"

	"github.com/getkin/kin-openapi/openapi3filter"
	nethttpmiddleware "github.com/oapi-codegen/nethttp-middleware"
	"github.com/rs/cors"

	"codeberg.org/cycas/app/gen/api"
	"codeberg.org/cycas/app/internal/transport/middleware/auth"
)

func NewHandler(svc api.StrictServerInterface) (http.Handler, error) {
	swagger, err := api.GetSwagger()
	if err != nil {
		return nil, err
	}

	handler := api.Handler(api.NewStrictHandler(svc, []api.StrictMiddlewareFunc{}))
	options := nethttpmiddleware.Options{
		SilenceServersWarning: true,
		Options: openapi3filter.Options{
			AuthenticationFunc: auth.Authenticate,
		},
	}

	c := cors.New(cors.Options{
		AllowedOrigins: []string{"http://localhost:5173"},
		AllowedMethods: []string{http.MethodGet},
		AllowedHeaders: []string{auth.AuthorizationHeaderKey},
	})

	return c.Handler(nethttpmiddleware.OapiRequestValidatorWithOptions(swagger, &options)(handler)), nil
}
