output "codebuild_projects" {
  value = { for k, v in aws_codebuild_project.cb : k => v.name }
}
