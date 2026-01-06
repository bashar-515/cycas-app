package main

import (
	"database/sql"
	"log"
	"os"

	"github.com/golang-migrate/migrate/v4"
	_ "github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	_ "github.com/lib/pq"

	"codeberg.org/cycas/app/internal/config"
)

func main() {
	cfg, err := config.Load()
	if err != nil {
		log.Fatal(err)
	}

	if err := provision(cfg.DatabaseUrl); err != nil {
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

func provision(databaseUrl string) error {
	db, err := sql.Open("postgres", databaseUrl)
	if err != nil {
		return err
	}
	defer db.Close() // TODO: check error

	provisionSql, err := os.ReadFile("db/provision.sql")
	if err != nil {
		return err
	}

	if _, err = db.Exec(string(provisionSql)); err != nil {
		return err
	}

	return nil
}
