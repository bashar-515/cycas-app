output "project_id" {
    value = var.project_name != null ? tfe_project.main[0].id : var.project_id
}
