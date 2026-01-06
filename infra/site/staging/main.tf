module "render" {
  source = "./modules/render"
}

module "cloudflare" {
  source = "./modules/cloudflare"

  content = replace(module.render.site_url, "https://", "")
}
