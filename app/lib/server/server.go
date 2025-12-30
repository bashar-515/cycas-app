package server

import (
	"context"
	"errors"
	"net/http"

	"github.com/oapi-codegen/nethttp-middleware"

	"codeberg.org/cycas/app/gen/api"
)

type Server struct{}

func NewServer() *Server {
	return &Server{}
}

func (s *Server) Handler() (http.Handler, error) {
	swagger, err := api.GetSwagger()
	if err != nil {
		return nil, err
	}

	handler := api.Handler(api.NewStrictHandler(s, []api.StrictMiddlewareFunc{}))
	options := nethttpmiddleware.Options{SilenceServersWarning: true }

	return nethttpmiddleware.OapiRequestValidatorWithOptions(swagger, &options)(handler), nil
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
