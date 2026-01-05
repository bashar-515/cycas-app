package server

import (
	"context"
	"errors"
	"fmt"
	"net/http"

	"github.com/getkin/kin-openapi/openapi3filter"
	"github.com/oapi-codegen/nethttp-middleware"
	"github.com/rs/cors"

	"codeberg.org/cycas/app/gen/api"
	"codeberg.org/cycas/app/internal/server/middleware/auth"
	"codeberg.org/cycas/app/internal/store"
)

type Server struct{
	database store.Store
}

func NewServer(store store.Store) *Server {
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

	c := cors.New(cors.Options{
		AllowedOrigins: []string{"http://localhost:5173"},
		AllowedMethods: []string{http.MethodGet},
		AllowedHeaders: []string{auth.AuthorizationHeaderKey},
	})

	return c.Handler(nethttpmiddleware.OapiRequestValidatorWithOptions(swagger, &options)(handler)), nil
}

func (s *Server) Ping(ctx context.Context, request api.PingRequestObject) (api.PingResponseObject, error) {
	v := ctx.Value(auth.CtxKeySub)
	sub, ok := v.(string)
	if !ok {
		fmt.Println("no sub")
	}

	fmt.Println(sub)
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
