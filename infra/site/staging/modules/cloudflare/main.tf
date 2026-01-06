data "cloudflare_zone" "main" {
  filter = {
    name = "cycas.dev"
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
    content = var.content

    proxied = local.proxied
}

resource "cloudflare_dns_record" "www" {
    name = "www"
    ttl = local.ttl
    type = local.type
    zone_id = data.cloudflare_zone.main.id
    content = var.content

    proxied = local.proxied
}
