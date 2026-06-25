module "tf_actions" {
  source = "../../../modules/ssm/v1.0"

  ssm_path          = "/pipelines/${var.cicd_name}/tf_actions"
  kms_alias         = "${local.naming_prefix}_pipelines_${var.cicd_name}"
  ssm_initial_value = "all_plan,all_apply"
}

module "tf_actions_destroy" {
  source = "../../../modules/ssm/v1.0"

  ssm_path          = "/pipelines/${var.cicd_name}/tf_actions_destroy"
  kms_alias         = "${local.naming_prefix}_pipelines_${var.cicd_name}_destroy"
  ssm_initial_value = "all_plan,all_destroy"
}
