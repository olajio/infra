module "secrets_manager_elastic_ad_service_elastic_auto" {
    source = "../../../../modules/sm_secret/v2.3"
    secret_name = "elastic/ad/service_elastic_auto"
    secret_description = "secret used by sql servers for monitoring"
    kms_key_id          = data.aws_kms_alias.sm.arn
    replica_region      = local.region_dr
    replica_kms_key_id  = data.aws_kms_alias.sm-virginia.arn
    tags = {
      Name          = "elastic-ad-service-elastic-auto"
      Environment   = var.environment
      abac_operator = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
      abac_admin    = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
    }
}


module "secrets_manager_agents_filebeat_password" {
    source = "../../../../modules/sm_secret/v2.3"
    secret_name = "onprem_provisioning/elastic_agents/filebeat"
    secret_description = "Password for filebeat agents"
    tags = {
      Name          = "elastic-agents-filebeat-password"
      Environment   = var.environment
      abac_operator = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
      abac_admin    = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
    }
}


module "secrets_manager_agents_metricbeat_password" {
    source = "../../../../modules/sm_secret/v2.3"
    secret_name = "onprem_provisioning/elastic_agents/metricbeat"
    secret_description = "Password for metricbeat agents"
    tags = {
      Name          = "elastic-agents-metricbeat-password"
      Environment   = var.environment
      abac_operator = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
      abac_admin    = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
    }
}


module "secrets_manager_agents_service_mesdp" {
    source = "../../../../modules/sm_secret/v2.3"
    secret_name = "onprem_provisioning/elastic_agents/service_mesdp"
    secret_description = "Service mesdp"
    tags = {
      Name          = "elastic-agents-service-mesdp"
      Environment   = var.environment
      abac_operator = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
      abac_admin    = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
    }
}


module "secrets_manager_agents_service_elastic" {
    source = "../../../../modules/sm_secret/v2.3"
    secret_name = "onprem_provisioning/elastic_agents/service_elastic"
    secret_description = "service_elastic"
    tags = {
      Name          = "elastic-agents-service-elastic"
      Environment   = var.environment
      abac_operator = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
      abac_admin    = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
    }
}


module "secrets_manager_agents_sql_metricbeat" {
    source = "../../../../modules/sm_secret/v2.3"
    secret_name = "onprem_provisioning/elastic_agents/sql_metricbeat"
    secret_description = "SQL credentials for custom queries via metricbeat"
    tags = {
      Name          = "elastic-agents-service-elastic"
      Environment   = var.environment
      abac_operator = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
      abac_admin    = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
    }
}


module "secret_manager_agents_verification" {
    source = "../../../../modules/sm_secret/v2.3"
    secret_name = "onprem_provisioning/elastic_agents/install_verification"
    secret_description = "credentials for connecting to CCS and checking for documents in metricbeat index"
    tags = {
      Name          = "elastic-agents-install-verification"
      Environment   = var.environment
      abac_operator = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
      abac_admin    = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
    }
}


module "secrets_manager_logstash_secrets" {
    source = "../../../../modules/sm_secret/v2.3"
    secret_name = "onprem/logstash/automation"
    secret_description = "Secret tokens used by logstash that are changed periodically"
    tags = {
      Name          = "onprem-logstash-automation"
      Environment   = var.environment
      abac_operator = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
      abac_admin    = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
    }
}

### add data for kms keys

data "aws_kms_alias" "sm" {
  name = "alias/aws/secretsmanager"
}
data "aws_kms_alias" "sm-virginia" {
  name = "alias/aws/secretsmanager"
  provider = aws.dr
}

module "secrets_manager_elastic" {
    source = "../../../../modules/sm_secret/v2.3"
    secret_name = "elastic/beats/api_key"
    secret_description = "Secret used by beat agents for Elastic"
    kms_key_id          = data.aws_kms_alias.sm.arn
    replica_region      = local.region_dr
    replica_kms_key_id  = data.aws_kms_alias.sm-virginia.arn
    tags = {
      Name          = "elastic/beats/api_key"
      Environment   = var.environment
      abac_operator = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
      abac_admin    = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
    }
}

module "secrets_manager_elastic_mon" {
    source = "../../../../modules/sm_secret/v2.3"
    secret_name = "elastic/beats/monitoring_api_key"
    secret_description = "Secret used by beat agents for monitoring"
    tags = {
      Name          = "elastic/beats/monitoring_api_key"
      Environment   = var.environment
      abac_operator = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
      abac_admin    = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
    }
}

data "template_file" "elastic_zero_touch_template" {
    template = file("policies/zero_touch_api_secret.json")

    vars = {
      service_roles = jsonencode([
        "arn:aws:iam::*:role/AnsibleCodeBuildCustomServiceRole",
        "arn:aws:iam::*:role/eks-sa-role-hs-zt2-api-us-east-2"
      ])
    }
}

data "template_file" "elastic_zero_touch_kms_template" {
    template = file("policies/zero_touch_api_secret_kms.json")

    vars = {
      organization_id = local.org_id
      account_id      = local.account_id
      service_roles = jsonencode([
        "arn:aws:iam::*:role/AnsibleCodeBuildCustomServiceRole",
        "arn:aws:iam::*:role/eks-sa-role-hs-zt2-api-us-east-2"
      ])
    }
}

module "secrets_manager_elastic_zero_touch" {
    source = "../../../../modules/sm_secret/v2.3"
    secret_name = "elastic/zero_touch/maintenance_api_key"
    secret_description = "Secret used by Zero Touch to set maintenance to servers in Elastic."
    secret_policy = data.template_file.elastic_zero_touch_template.rendered
    kms_key_policy = data.template_file.elastic_zero_touch_kms_template.rendered
    default_encryption = false
    tags = {
      Name          = "elastic/zero_touch/maintenance_api_key"
      Environment   = var.environment
      abac_operator = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma} ${local.lz_adfs_account_roles_outputs.abac_codes.cai}"
      abac_admin    = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma} ${local.lz_adfs_account_roles_outputs.abac_codes.cai}"
    }
}


module "secrets_manager_alarm_decision_framework_shd"{
    source = "../../../../modules/sm_secret/v2.3"
    secret_name = "alarm_decision_framework/apigw/tokens"
    secret_description = "secret used by decision framework for api gateway tokens"
    kms_key_id          = data.aws_kms_alias.sm.arn
    replica_region      = local.region_dr
    replica_kms_key_id  = data.aws_kms_alias.sm-virginia.arn


    tags = {
      Name          = "alarm_decision_framework-apigw-tokens"
      Environment   = var.environment
      abac_operator = "${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
      abac_admin    = "${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
    }
}

module "secrets_manager_alarm_decision_framework_api_update_shd"{
    source = "../../../../modules/sm_secret/v2.3"
    secret_name = "alarm_decision_framework/apigw/dyndb_update_tokens"
    secret_description = "secret used by dfw for API GW tokens, update dyndb amdb table"
    kms_key_id          = data.aws_kms_alias.sm.arn
    replica_region      = local.region_dr
    replica_kms_key_id  = data.aws_kms_alias.sm-virginia.arn


    tags = {
      Name          = "alarm_decision_framework-apigw-dyndb-amdb-tokens"
      Environment   = var.environment
      abac_operator = "${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
      abac_admin    = "${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
    }
}

module "secrets_manager_github_hsv_internal_itsma_service_elastic_auto" {
    source = "../../../../modules/sm_secret/v2.3"
    secret_name = "github_hsv_internal/itsma/service_elastic_auto_HSV"
    secret_description = "Service elastic auto credentials for GitHub HSV Internal ITSMA"
    kms_key_id          = data.aws_kms_alias.sm.arn
    replica_region      = local.region_dr
    replica_kms_key_id  = data.aws_kms_alias.sm-virginia.arn
    tags = {
      Name          = "github-hsv-internal-itsma-service-elastic-auto-hsv"
      Environment   = var.environment
      abac_operator = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma} ${local.lz_adfs_account_roles_outputs.abac_codes.elk}"
      abac_admin    = "${local.lz_adfs_account_roles_outputs.abac_codes.are} ${local.lz_adfs_account_roles_outputs.abac_codes.itsma} ${local.lz_adfs_account_roles_outputs.abac_codes.elk}"
    }
}

module "secrets_manager_codebuild_kibana_token_shd"{
    source = "../../../../modules/sm_secret/v2.3"
    secret_name = "elastic/kibana/token_alert_rules"
    secret_description = "secret used by codebuild to sync Kibana alert rules with github repo"
    kms_key_id          = data.aws_kms_alias.sm.arn
    replica_region      = local.region_dr
    replica_kms_key_id  = data.aws_kms_alias.sm-virginia.arn


    tags = {
      Name          = "elastic-kibana_alert_rules"
      Environment   = var.environment
      abac_operator = "${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
      abac_admin    = "${local.lz_adfs_account_roles_outputs.abac_codes.itsma}"
    }
}