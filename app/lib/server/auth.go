package server

import (
	"context"
	"fmt"
	"strings"

	"github.com/getkin/kin-openapi/openapi3filter"
)

const (
	authorizationHeaderKey = "Authorization"
	bearerPrefix = "Bearer "
)

func authenticate(ctx context.Context, input *openapi3filter.AuthenticationInput) error {
	req := input.RequestValidationInput.Request

	authHeader := req.Header.Get(authorizationHeaderKey)
	if authHeader == "" {
		// TODO: handle case
		fmt.Println("Authorization missing")
	}

	if !strings.HasPrefix(authHeader, bearerPrefix) {
		// TODO: handle case
		fmt.Println("Bearer missing")
	}

	token := strings.TrimPrefix(authHeader, bearerPrefix)

	if token == "" {
		// TODO: handle case
		fmt.Println("Token missing")
	}

	// TODO: validate token

	ctx = context.WithValue(ctx, "token", token)
	input.RequestValidationInput.Request = req.WithContext(context.WithValue(req.Context(), "token", token))

	return nil
}
