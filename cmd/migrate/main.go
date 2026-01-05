package main

import (
	"log"

	"github.com/golang-migrate/migrate/v4"
	_ "github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"

	"codeberg.org/cycas/app/internal/config"
)

func main() {
	cfg, err := config.Load()
	if err != nil {
		log.Fatal(err)
	}

	m, err := migrate.New("file://db/migrations", cfg.DatabaseUrl)
	if err != nil {
		log.Fatal(err)
	}

	if err = m.Up(); err != nil && err != migrate.ErrNoChange {
		log.Fatal(err)
	}
}
