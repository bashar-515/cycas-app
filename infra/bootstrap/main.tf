resource "tfe_organization" "main" {
  name = "Cycas-01"
  email = var.email
}

module "site_staging" {
  source = "./modules/tfe"

  project_name = "Site"
  organization_name = tfe_organization.main.name
  workspace_name = "site-staging"
}

module "site_production" {
  source = "./modules/tfe"

  project_id = module.site_staging.project_id
  organization_name = tfe_organization.main.name
  workspace_name = "site-production"
}

module "web_staging" {
  source = "./modules/tfe"

  project_name = "Web"
  organization_name = tfe_organization.main.name
  workspace_name = "web-staging"
}

module "web_production" {
  source = "./modules/tfe"

  project_id = module.web_staging.project_id
  organization_name = tfe_organization.main.name
  workspace_name = "web-production"
}
