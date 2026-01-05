CREATE TABLE users (
    id TEXT PRIMARY KEY,
    created_at timestamptz NOT NULL DEFAULT now()
);
