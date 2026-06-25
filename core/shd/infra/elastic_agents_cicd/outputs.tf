output "codebuild_plan_name" {
  value = aws_codebuild_project.cb_plan.name
}

output "codebuild_apply_name" {
  value = aws_codebuild_project.cb_apply.name
}

output "codebuild_plan_destroy_name" {
  value = aws_codebuild_project.cb_plan_destroy.name
}

output "codebuild_apply_destroy_name" {
  value = aws_codebuild_project.cb_apply_destroy.name
}