// context variables, can be overriden during module implementation
locals {
  org_id     = coalesce(var.org_id, data.aws_organizations_organization.current.id)
  region     = coalesce(var.region, data.aws_region.current.name)
  account_id = coalesce(var.account_id, data.aws_caller_identity.current.account_id)
}

locals {
  vpc_id                  = data.terraform_remote_state.org_networking.outputs.lz_shared_vpc_id
  subnet_ids              = data.terraform_remote_state.org_networking.outputs.lz_shared_private_subnet_ids
  artifacts_s3_name       = data.terraform_remote_state.shd_bootstrap.outputs["shared"].artifacts_s3_bucket_name
  artifacts_s3_kms_id     = data.terraform_remote_state.shd_bootstrap.outputs["shared"].artifacts_s3_kms_key_id
  artifacts_s3_kms_arn    = data.terraform_remote_state.shd_bootstrap.outputs["shared"].artifacts_s3_kms_key_arn
  state_s3_name           = data.terraform_remote_state.shd_bootstrap.outputs["shared"].state_s3_bucket_name
  state_s3_kms_id         = data.terraform_remote_state.shd_bootstrap.outputs["shared"].state_s3_kms_key_id
  state_s3_kms_arn        = data.terraform_remote_state.shd_bootstrap.outputs["shared"].state_s3_kms_key_arn
  codepipeline_role_arn   = data.terraform_remote_state.shd_bootstrap.outputs["shared"].codepipeline_role_arn
  codepipeline_role_id    = data.terraform_remote_state.shd_bootstrap.outputs["shared"].codepipeline_role_id
  codepipeline_role_name  = data.terraform_remote_state.shd_bootstrap.outputs["shared"].codepipeline_role_name
  codebuild_role_arn      = data.terraform_remote_state.shd_bootstrap.outputs["shared"].codebuild_role_arn
  codebuild_role_id       = data.terraform_remote_state.shd_bootstrap.outputs["shared"].codebuild_role_id
  codebuild_role_name     = data.terraform_remote_state.shd_bootstrap.outputs["shared"].codebuild_role_name
  codebuil_security_group = data.terraform_remote_state.shd_bootstrap.outputs["shared"].codebuild_bootstrap_security_group_id
	more_tags = {
		abac_operator = "${data.terraform_remote_state.lz_adfs_account_roles.outputs.abac_codes.are} ${data.terraform_remote_state.lz_adfs_account_roles.outputs.abac_codes.cai} ${data.terraform_remote_state.lz_adfs_account_roles.outputs.abac_codes.plateng}"
	}
  start_trigger_cw_event_rule = "start_cicd"

  cb_app_codes  = { for k,v in local.codebuilds: k => v.codebuild_parameters["appcode"] if contains(keys(v.codebuild_parameters), "appcode") }
  cb_extra_tags = { for k,v in local.cb_app_codes : k => module.aws_cb_tags[k] }
}

locals {
	abac = data.terraform_remote_state.lz_adfs_account_roles.outputs.abac_codes
}