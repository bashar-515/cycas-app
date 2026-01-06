resource "cloudflare_pages_project" "main" {
    account_id = var.account_id
    name = var.project_name
    production_branch = "main"

    build_config = {
      root_dir = "public"
    }

    deployment_configs = {
      production = {
        fail_open = false
      }

      preview = {
        fail_open = false
      }
    }

    source = {
      type = "github"

      config = {
        owner = "bashar-515"

        path_includes = [
          "public/**",
        ]

        production_branch = "main"
        production_deployments_enabled = true
        repo_name = "cycas-site"
      }
    }
}

locals {
  www_domain_name = "www.${var.apex_domain_name}"
}

resource "cloudflare_pages_domain" "apex" {
  account_id = var.account_id
  name = var.apex_domain_name
  project_name = cloudflare_pages_project.main.name
}

resource "cloudflare_pages_domain" "www" {
  account_id = var.account_id
  name = local.www_domain_name
  project_name = cloudflare_pages_project.main.name
}

data "cloudflare_zone" "main" {
  filter = {
    name = var.apex_domain_name
  }
}

locals {
  ttl = 1
  type = "CNAME"
  proxied = true
}

resource "cloudflare_dns_record" "apex" {
    name = "@"
    ttl = local.ttl
    type = local.type
    zone_id = data.cloudflare_zone.main.id
    content = cloudflare_pages_project.main.subdomain

    proxied = local.proxied
}

resource "cloudflare_dns_record" "www" {
    name = "www"
    ttl = local.ttl
    type = local.type
    zone_id = data.cloudflare_zone.main.id
    content = cloudflare_pages_project.main.subdomain

    proxied = local.proxied
}

resource "cloudflare_ruleset" "main" {
  zone_id = data.cloudflare_zone.main.id

  kind = "zone"
  name = "redirect"
  phase = "http_request_dynamic_redirect"

  rules = [
    {
      action = "redirect"
      expression = "(http.host eq \"${local.www_domain_name}\")"

      action_parameters = {
        from_value = {
          status_code = 301
          preserve_query_string = true

          target_url = {
            expression = "concat(\"https://${var.apex_domain_name}\", http.request.uri.path)"
          }
        }
      }
    }
  ]
}
