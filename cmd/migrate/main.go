package main

import (
	"github.com/golang-migrate/migrate/v4"
  _ "github.com/golang-migrate/migrate/v4/database/postgres"

	"codeberg.org/cycas/app/internal/config"
)

func main() {
	cfg, err := config.Load()
	if err != nil {
		// TODO: handle error
	}

	m, err := migrate.New("file://db/migrations", cfg.DatabaseUrl)
	if err != nil {
		// TODO: handle erro
	}

	if err = m.Up(); err != nil && err != migrate.ErrNoChange {
		// TODO: handle erro
	}
}
