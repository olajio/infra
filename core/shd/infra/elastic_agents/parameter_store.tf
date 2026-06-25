resource "aws_ssm_parameter" "known_codes" {
  name        = "app-codes_in_role"
  description = "APP-CODEs exist in the ansible role for MT"
  type        = "String"
  insecure_value       = "HADES,SMTPX"
  tags = {
    abac_operator = local.lz_adfs_account_roles_outputs.abac_codes.itsma
    abac_admin    = local.lz_adfs_account_roles_outputs.abac_codes.itsma
	}
}

resource "aws_ssm_parameter" "unknown_codes" {
  name        = "app-codes_to_ignore"
  description = "APP-CODEs that must be ignored by CodeBuild."
  type        = "String"
  insecure_value       = "EKSWN,TEST"
  tags = {
    abac_operator = local.lz_adfs_account_roles_outputs.abac_codes.itsma
    abac_admin    = local.lz_adfs_account_roles_outputs.abac_codes.itsma
	}
}
