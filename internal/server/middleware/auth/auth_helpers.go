package auth

import (
	"net/http"
	"strings"

	"github.com/golang-jwt/jwt/v5"
)

const (
	bearerPrefix = "Bearer "
)

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
