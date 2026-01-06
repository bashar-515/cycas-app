resource "render_static_site" "main" {
    branch = "main"
    build_command = ""
    name = "cycas site"
    repo_url = "https://github.com/bashar-515/cycas-site"

    auto_deploy = true

    build_filter = {
      paths = [
        "public/**",
      ]
    }

    custom_domains = [
      { name: "cycas.dev" },
    ]

    publish_path = "public"
}
