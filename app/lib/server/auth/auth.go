package auth

import (
	"context"
	"fmt"

	"github.com/getkin/kin-openapi/openapi3filter"
)

type ctxKey int

const (
 	AuthorizationHeaderKey = "Authorization"

	CtxKeySub ctxKey = iota
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

	fmt.Println(sub)

	input.RequestValidationInput.Request = req.WithContext(context.WithValue(req.Context(), CtxKeySub, sub))

	return nil
}
