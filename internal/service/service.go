package service

import (
	"context"
	"errors"
	"fmt"

	"codeberg.org/cycas/app/gen/api"
	"codeberg.org/cycas/app/internal/session"
	"codeberg.org/cycas/app/internal/store"
)

type Service struct{
	store store.Store
}

func NewService(st store.Store) api.StrictServerInterface {
	return &Service{
		store: st,
	}
}

func (s *Service) Ping(ctx context.Context, request api.PingRequestObject) (api.PingResponseObject, error) {
	v := ctx.Value(session.CtxKeySub)
	sub, ok := v.(string)
	if !ok {
		fmt.Println("no sub")
	}

	fmt.Println(sub)
	return api.Ping200TextResponse("Hello, World!"), nil
}

func (s *Service) CreateCategory(
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
