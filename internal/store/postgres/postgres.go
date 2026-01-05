package postgres

import (
	"context"

	"github.com/jackc/pgx/v5/pgxpool"

	"codeberg.org/cycas/app/internal/store"
)

type Postgres struct {
	pool *pgxpool.Pool
}

var _ store.Store = (*Postgres)(nil)

func New(ctx context.Context, connString string) (*Postgres, error) {
	pool, err := pgxpool.New(ctx, connString)
	if err != nil {
		// TODO: handle error
	}

	return &Postgres{
		pool: pool,
	}, nil
}

func (pg *Postgres) Close() {
	pg.pool.Close()
}

func (pg *Postgres) CreateCategory() {}
