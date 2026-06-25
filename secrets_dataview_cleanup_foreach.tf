###############################################################################
# Per-cluster Kibana/Elasticsearch secrets for the duplicate data view cleanup
# tool — for_each variant (one block, one source of truth).
#
# Placement: core/shd/infra/elastic_agents/ alongside secrets.tf, so it reuses
# (does NOT re-declare) the existing module-scope objects already defined there:
#   - data.aws_kms_alias.sm            (us-east-2 secretsmanager CMK alias)
#   - data.aws_kms_alias.sm-virginia   (us-east-1 replica CMK alias, provider aws.dr)
#   - local.region_dr                  (us-east-1)
#   - local.lz_adfs_account_roles_outputs.abac_codes.*
#
# Each secret holds BOTH values for that cluster as a JSON document:
#   { "kibana_url": "https://<cluster-host>:9243", "es_api_key": "<api key>" }
# Blocks only provision the container; the JSON value is populated out-of-band.
#
# The Python resolves the name deterministically from --cluster_name:
#   secret_name = f"elastic/kibana/dataview_cleanup_{cluster_name}"
#
# Reference ARNs by key when writing the IAM policy, e.g.:
#   module.secrets_manager_kibana_dataview_cleanup["prod"].secret_arn
#
# ABAC: matches the sibling github_hsv_internal/itsma/service_elastic_auto_HSV
# secret (are + itsma + elk). Confirm these codes with whoever owns IAM/ABAC.
#
# GitHub PAT: NOT created here — reuse the existing
# github_hsv_internal/itsma/service_elastic_auto_HSV secret.
###############################################################################

locals {
  dataview_cleanup_clusters = ["dev", "qa", "prod", "ccs"]
}

module "secrets_manager_kibana_dataview_cleanup" {
  source   = "../../../../modules/sm_secret/v2.3"
  for_each = toset(local.dataview_cleanup_clusters)

  secret_name        = "elastic/kibana/dataview_cleanup_${each.key}"
  secret_description = "Kibana URL and Elasticsearch API key for the ${each.key} cluster (duplicate data view cleanup)"
  kms_key_id         = data.aws_kms_alias.sm.arn
  replica_region     = local.region_dr
  replica_kms_key_id = data.aws_kms_alias.sm-virginia.arn
  tags = {
    Name          = "elastic-kibana-dataview-cleanup-${each.key}"
    Environment   = var.environment
    abac_operator = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma} ${local.lz_adfs_account_roles_outputs.abac_codes.elk}"
    abac_admin    = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma} ${local.lz_adfs_account_roles_outputs.abac_codes.elk}"
  }
}
