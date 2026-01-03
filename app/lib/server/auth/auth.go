package auth

import (
	"context"

	"github.com/getkin/kin-openapi/openapi3filter"
)

type ctxKey int

const (
	ctxKeySub ctxKey = iota
)

func Authenticate(ctx context.Context, input *openapi3filter.AuthenticationInput) error {
	req := input.RequestValidationInput.Request

	token, err := getTokenFromRequest(req)
	if err != nil {
		// TODO: handle error
	}	

	sub, err := extractSubFromUnverifiedToken(token) // TODO: validate token
	if err != nil {
		// TODO: handle error
	}

	input.RequestValidationInput.Request = req.WithContext(context.WithValue(req.Context(), ctxKeySub, sub))

	return nil
}
