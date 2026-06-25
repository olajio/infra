locals {
  naming_prefix_generated = "${var.ou}-${var.environment}-${var.component}-${local.region}"
  naming_prefix           = coalesce(var.naming_prefix, local.naming_prefix_generated)

  codepipeline_name = coalesce(var.codepipeline_name, "${local.naming_prefix}-cp-${var.solution_name}")
  codebuild_name    = coalesce(var.codebuild_name, "${local.naming_prefix}-cb-${var.solution_name}")
}
