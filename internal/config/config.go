package config

import (
	"os"

	_ "github.com/joho/godotenv/autoload"
)

type Config struct {
	DatabaseUrl string
}

func Load() (Config, error) {
	databaseUrl, ok := os.LookupEnv("CYCAS_DATABASE_URL")
	if !ok {
		// TODO: handle case
	}

	return Config{
		DatabaseUrl: databaseUrl,
	}, nil
}
