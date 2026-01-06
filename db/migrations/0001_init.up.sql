CREATE TABLE users (
    id TEXT PRIMARY KEY,
    category_limit integer NOT NULL DEFAULT 6,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE categories (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id text NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name TEXT NOT NULL
        CHECK(
            length(name) BETWEEN 3 and 32
            AND name ~ '^[a-z](?:[a-z -]{1,30}[a-z])?$'
        ),
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX categories_user_id ON categories(user_id);
CREATE UNIQUE INDEX categories_user_id_name ON categories(user_id, name);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE users FORCE ROW LEVEL SECURITY;

CREATE POLICY users_all
    ON users
    FOR ALL
    USING (id = current_setting('app.user_id', true))
    WITH CHECK (id = current_setting('app.user_id', true));

ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories FORCE ROW LEVEL SECURITY;

CREATE POLICY categories_user_all
    ON categories
    FOR ALL
    USING (user_id = current_setting('app.user_id', true))
    WITH CHECK (user_id = current_setting('app.user_id', true));
