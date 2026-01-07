resource "render_static_site" "main" {
    branch = "main"
    build_command = "true"
    name = "cycas site"
    repo_url = "https://github.com/bashar-515/cycas-app"

    auto_deploy = true

    build_filter = {
      paths = [
        "site/public/**",
      ]
    }

    custom_domains = [
      { name: "cycas.dev" },
    ]

    publish_path = "site/public"
}
