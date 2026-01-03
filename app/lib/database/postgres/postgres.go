package postgres

import (
	"context"

	"github.com/jackc/pgx/v5/pgxpool"

	"codeberg.org/cycas/app/app/lib/server"
)

type Database struct {
	pool *pgxpool.Pool
}

var _ server.Database = (*Database)(nil)

func New(ctx context.Context, connString string) (*Database, error) {
	pool, err := pgxpool.New(ctx, connString)
	if err != nil {
		// TODO: handle error
	}

	return &Database{
		pool: pool,
	}, nil
}

func (d *Database) Close() {
	d.pool.Close()
}

func (d *Database) CreateCategory() {}
