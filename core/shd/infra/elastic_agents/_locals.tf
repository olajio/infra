 // context variables, can be overriden during module implementation
 locals {
   org_id     = coalesce(var.org_id, data.aws_organizations_organization.current.id)
   region     = coalesce(var.region, data.aws_region.current.name)
   region_dr  = var.region_virginia
   account_id = coalesce(var.account_id, data.aws_caller_identity.current.account_id)
 }

 // naming prefix, it is produced from ou, environment, region and module, but can be overriden
 //   at module implementatation using naming_prefix
 locals {
   naming_prefix_generated = "${var.ou}-${var.environment}-${var.component}-${local.region}"
   naming_prefix           = coalesce(var.naming_prefix, local.naming_prefix_generated)
 }

# locals {
#   solution_name         = reverse(split("/", path.cwd))[0]
#   cb_runtime_image_name = coalesce(var.cb_runtime_image_name, "${local.naming_prefix}-img-${var.cb_runtime_image_name_sfx}")
#   cb_runtime_image      = coalesce(var.cb_runtime_image, "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/${local.cb_runtime_image_name}:${var.cb_runtime_version}")
# }

 # Account IDs
 locals {
   accounts_list = [for account in local.lz_avm_outputs.accounts : account["account_id"] if account["ou"] == "app" || account["ou"] == "poc" || account["ou"] == "Unmanaged" ]
 }

locals {
   lz_avm_outputs = data.terraform_remote_state.lz_avm.outputs
   lz_adfs_account_roles_outputs = data.terraform_remote_state.lz_adfs_account_roles.outputs
   lz_accounts_outputs = data.terraform_remote_state.lz_accounts.outputs
}

# Org structure used for cross-account event bus access in parent, security, network, shared, logging and all workload (app + poc) accounts.
locals {
  org_root_id = local.lz_accounts_outputs.root_id

  cross_account_event_bus_ou_paths = concat(
    ["${local.org_id}/${local.org_root_id}/${local.lz_accounts_outputs.ou_id_core}/*"],
    [for ou_id in values(local.lz_accounts_outputs.ou_map_workload) :
      "${local.org_id}/${local.org_root_id}/${ou_id}/*"
    ],
  )
}
