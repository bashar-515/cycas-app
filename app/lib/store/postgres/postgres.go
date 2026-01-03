package postgres

import (
	"context"

	"github.com/jackc/pgx/v5/pgxpool"

	"codeberg.org/cycas/app/app/lib/server"
)

type Postgres struct {
	pool *pgxpool.Pool
}

var _ server.Store = (*Postgres)(nil)

func New(ctx context.Context, connString string) (*Postgres, error) {
	pool, err := pgxpool.New(ctx, connString)
	if err != nil {
		// TODO: handle error
	}

	return &Postgres{
		pool: pool,
	}, nil
}

func (p *Postgres) Init() {}

func (p *Postgres) Close() {
	p.pool.Close()
}

func (d *Postgres) CreateCategory() {}
