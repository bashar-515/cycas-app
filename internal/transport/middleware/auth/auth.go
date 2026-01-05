package auth

import (
	"context"
	"fmt"
	"net/http"
	"strings"

	"github.com/getkin/kin-openapi/openapi3filter"
	"github.com/golang-jwt/jwt/v5"
)

type ctxKey int

const (
	CtxKeySub ctxKey = iota

 	AuthorizationHeaderKey = "Authorization"

	bearerPrefix = "Bearer "
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

func getTokenFromRequest(r *http.Request) (string, error) {
	authorizationHeader := r.Header.Get(AuthorizationHeaderKey)
	if authorizationHeader == "" {
		// TODO: return error
	}

	if !strings.HasPrefix(authorizationHeader, bearerPrefix) {
		// TODO: return error
	}

	token := strings.TrimSpace(strings.TrimPrefix(authorizationHeader, bearerPrefix))
	if token == "" {
		// TODO: return error
	}

	return token, nil
}

func extractSubFromUnverifiedToken(token string) (string, error) {
	parser := jwt.NewParser(jwt.WithoutClaimsValidation())

	t, _, err := parser.ParseUnverified(token, jwt.MapClaims{})
	if err != nil {
		// TODO: handle error
	}

	claims := t.Claims.(jwt.MapClaims)

	sub, ok := claims["sub"].(string)
	if !ok {
		// TODO: handle case
	}

	return sub, nil
}
