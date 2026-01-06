resource "render_static_site" "main" {
    branch = "main"
    build_command = "npm run build"
    name = "cycas app"
    repo_url = "https://github.com/bashar-515/cycas-app"

    auto_deploy = true

    build_filter = {
      paths = [
        "e2e/**",
        "src/**",
        "static/**",
        ".npmrc",
        ".prettierignore",
        ".prettierrc",
        "eslint.config.js",
        "package.json",
        "playwright.config.ts",
        "pnpm-lock.yaml",
        "pnpm-workspace.yaml",
        "svelte.config.js",
        "tsconfig.json",
        "vite.config.ts",
      ]
    }

    custom_domains = [
      { name: "app.cycas.dev" },
    ]

    env_vars = {
      PUBLIC_OIDC_AUTHORITY = {
        value = "https://cycas-instance-rff81g.us1.zitadel.cloud"
      }
      PUBLIC_OIDC_CLIENT_ID = {
        value = "353278728903597183"
      }
      PUBLIC_OIDC_REDIRECT_URI = {
        value = "https://app.cycas.dev/callback"
      }
      PUBLIC_OIDC_POST_LOGOUT_REDIRECT_URI = {
        value = "https://app.cycas.dev"
      }
    }

    publish_path = "build"
}
