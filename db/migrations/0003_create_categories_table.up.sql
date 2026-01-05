CREATE TABLE categories (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id text NOT NULL DEFAULT auth.user_id(),
    name text NOT NULL CHECK (char_length(name) BETWEEN 3 AND 32),
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX categories_user_id ON categories(user_id);

ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY categories_user_all
    ON categories
    FOR ALL
    USING (user_id = auth.user_id())
    WITH CHECK (user_id = auth.user_id());
