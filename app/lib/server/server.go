package server

import (
	"context"
	"errors"
	"net/http"

	"github.com/getkin/kin-openapi/openapi3filter"
	"github.com/oapi-codegen/nethttp-middleware"
	"github.com/rs/cors"

	"codeberg.org/cycas/app/gen/api"
	"codeberg.org/cycas/app/app/lib/server/auth"
)

type Store interface {
	CreateCategory()
}

type Server struct{
	database Store
}

func NewServer(store Store) *Server {
	return &Server{
		database: store,
	}
}

func (s *Server) Handler() (http.Handler, error) {
	swagger, err := api.GetSwagger()
	if err != nil {
		return nil, err
	}

	handler := api.Handler(api.NewStrictHandler(s, []api.StrictMiddlewareFunc{}))
	options := nethttpmiddleware.Options{
		SilenceServersWarning: true,
		Options: openapi3filter.Options{
			AuthenticationFunc: auth.Authenticate,
		},
	}

	cors := cors.New(cors.Options{
		AllowedOrigins: []string{"http://localhost:5173"},
		AllowedMethods: []string{http.MethodGet},
		AllowedHeaders: []string{auth.AuthorizationHeaderKey},
	})

	return cors.Handler(nethttpmiddleware.OapiRequestValidatorWithOptions(swagger, &options)(handler)), nil
}

func (s *Server) Ping(ctx context.Context, request api.PingRequestObject) (api.PingResponseObject, error) {
	return api.Ping200TextResponse("Hello, World!"), nil
}

func (s *Server) CreateCategory(
	ctx context.Context,
	request api.CreateCategoryRequestObject,
) (api.CreateCategoryResponseObject, error) {
	if request.Body == nil {
		return nil, errors.New("request body is nil")
	}

	if request.Body.Name == "foo" {
		return api.CreateCategory201JSONResponse{Id: "abc123", Name: request.Body.Name}, nil
	}

	return api.CreateCategory409JSONResponse{Error: "Category must be named foo"}, nil
}
