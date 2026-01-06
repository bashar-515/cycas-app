resource "tfe_project" "main" {
  count = var.project_name != null ? 1 : 0

  name = var.project_name
  organization = var.organization_name
}

resource "tfe_workspace" "main" {
  name = var.workspace_name
  organization = var.organization_name
  project_id = var.project_name != null ? tfe_project.main[0].id : var.project_id

  force_delete = var.force_delete
}

resource "tfe_workspace_settings" "main" {
  workspace_id = tfe_workspace.main.id
  execution_mode = "local"
}
