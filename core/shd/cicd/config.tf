#Order of stages is determined by their names, sorted alphabetically. Name stages properly, to achieve desired order.
locals {
  pipeline = {
    s10 = ["image_factories_cicd", "release_cicd", "webhook_wendy_cicd", "library_factories_cicd"]
    s20 = [
        "ansible_cicd",
        "app_planonly_cicd",
        "alarm_decision_framework_cicd",
        "app_release_monitoring_cicd",
        "image_scanner_cicd",
        "adds_cicd",
        "smtp_cicd",
        "paloalto_cicd",
        "r53_cicd",
        "auth_cicd",
        "elastic_agents_cicd",
        "onprem_provisioning_cicd",
        "onprem_provisioning_pipelines_cicd",
        "planonly_lambda_cicd",
        "jenkins_trigger_cicd",
        "codebuild_trigger_cicd",
        "elastic_scale_up_cicd",
        "amazonlinux_version_update_cicd",
        "chef_promote_job_cicd",
        "failed_pipelines_lambda_sns_cicd",
        "onprem_legacydr_cicd",
        "hi_db_copy_cicd",
        "lambda_image_tagging_cicd",
        "roles_anywhere_cicd",
        "hi_asgard_job_cicd",
        "codeartifact_cicd",
        "zero_touch_cicd",
        "zt2_cicd",
        "managed_grafana_cicd",
        "managed_grafana_cac_cicd",
        "artifactory_aws_migrate_cicd",
        "pv_codebuild_jobs_cicd",
        "pulp_rpm_cicd",
        "ghe_validation_lambda_cicd",
        "upload_consul_lambda_cicd",
        "storage_gateway_cicd",
        "storage_gateway_prod_cicd",
        "ova_conversion_cb_cicd",
        "weekly_mgmt_ami_job_cicd",
        "eventbridge_delete_rule_cicd",
        "mgmt_box_prod_release_lambda_cicd",
        "avm_prod_release_lambda_cicd",
        "tf_docs_webhook_cb_cicd",
        "numerix_license_server_cicd",
        "numerix_license_server_prod_cicd",
        "business_calendar_bucket_cicd",
        "azure_tf_state_bucket_cicd",
        "lambda_factories_cicd",
        "infoblox_cicd",
        "fsx_ontap_cicd",
        "start_stop_legacydr_cicd",
        "image_validation_cicd",
        "fsx_ontap_prod_cicd",
        "bedrock_cicd",
        "monitor_zticd_node_uptime_cicd",
        "voice_cb_cicd",
        "azure_cicd",
        "frontend_testing_box_cicd",
        "hs_main_fm_stats_cicd",
        "edb2edb_cicd",
        "api_gw_github_hooks_cicd",
        "qa_hub_cicd",
        "release_version_validator_cicd",
        "github_repo_creation_cicd",
        "github_api_rate_limit_monitor_cicd",
        "standards_checker_cicd",
        "jenkins_trigger_dev_cicd",
        "cleanup_releases_job_cicd",
        "sagemaker_a2i_cicd",
        "textract_cicd",
        "hs_main_pr_validator_cicd",
        "clientqa_files_sync_cicd",
        "clientqa_tc_job_cicd",
        "hs_main_linter_cicd",
        "micro_release_branch_creation_cicd",
        "image_factories_base_image_update_cicd",
        "git_con_cicd",
        "geus_automation_cicd",
        "aws_devops_agent_cicd",
        "hs_main_branch_cut_cicd",
        "release_scheduler_cicd"
      ]
  }

  codebuilds = {
    app_release_monitoring_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
        })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
        })
    }

    alarm_decision_framework_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
        })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
        })
    }

    library_factories_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
        })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
        })
    }

    image_factories_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    release_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    webhook_wendy_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    app_planonly_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
            image_url     = data.terraform_remote_state.image_factory_platform_terraform.outputs.image_factory.infra_image_ecr_url
            image_version = "latest"
          #put overrides from defaults here
          appcode = "CCICD"
        })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    image_scanner_cicd = {
        codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,{
            #put overrides from defaults here
            appcode = "CCICD"
            })
        action = merge(local.codebuilds_defaults.action,{
            #put overrides from defaults here
        })
    }

    ansible_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    adds_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "WADDS"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    smtp_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "SMTPR"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    paloalto_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    r53_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    auth_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "WAUTH"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    elastic_scale_up_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
            image_url     = data.terraform_remote_state.image_factory_platform_terraform.outputs.image_factory.infra_image_ecr_url
            image_version = "latest"
          #put overrides from defaults here
        })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    elastic_agents_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }


    onprem_provisioning_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    onprem_provisioning_pipelines_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    planonly_lambda_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    jenkins_trigger_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    codebuild_trigger_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    amazonlinux_version_update_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    chef_promote_job_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    failed_pipelines_lambda_sns_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    onprem_legacydr_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    hi_db_copy_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    lambda_image_tagging_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    roles_anywhere_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    hi_asgard_job_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    codeartifact_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    zero_touch_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "ZTICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    zt2_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "ZTICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    managed_grafana_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    managed_grafana_cac_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    artifactory_aws_migrate_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    pv_codebuild_jobs_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    pulp_rpm_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "HSPLP"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    ghe_validation_lambda_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CAITS"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    upload_consul_lambda_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    storage_gateway_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "STGSRV"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
     storage_gateway_prod_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "STGSRV"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    ova_conversion_cb_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    weekly_mgmt_ami_job_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "ICICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    eventbridge_delete_rule_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    mgmt_box_prod_release_lambda_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    avm_prod_release_lambda_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    tf_docs_webhook_cb_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    numerix_license_server_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "NUMERIX"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    numerix_license_server_prod_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "NUMERIX"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    business_calendar_bucket_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "ICICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    azure_tf_state_bucket_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "ICICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    lambda_factories_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    infoblox_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "IBDNS"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    fsx_ontap_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "FSXOT"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    start_stop_legacydr_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
   image_validation_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "MSSQL"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    fsx_ontap_prod_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "FSXOT"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    bedrock_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "ICICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    monitor_zticd_node_uptime_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "ZTICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    voice_cb_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    azure_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "ICICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    frontend_testing_box_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    hs_main_fm_stats_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "HSMCS"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    edb2edb_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    api_gw_github_hooks_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    qa_hub_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "QAHUB"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    release_version_validator_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "HSMCS"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    github_repo_creation_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    github_api_rate_limit_monitor_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    standards_checker_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "ICICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    jenkins_trigger_dev_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    cleanup_releases_job_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    sagemaker_a2i_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "RPAIDM"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    textract_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "RPAIDM"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    hs_main_pr_validator_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "HSMCS"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    clientqa_tc_job_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CLNTQA"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    clientqa_files_sync_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CLNTQA"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    hs_main_linter_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "HSMCS"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    micro_release_branch_creation_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "HSMCS"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }
    image_factories_base_image_update_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    image_factories_base_image_update_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    git_con_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    geus_automation_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "CCICD"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    aws_devops_agent_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    hs_main_branch_cut_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "HSMCS"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }

    release_scheduler_cicd = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
        {
          #put overrides from defaults here
          appcode = "HSMCS"
      })
      action = merge(local.codebuilds_defaults.action,
        {
          #put overrides from defaults here
      })
    }


  }
}
locals {
  codebuilds_defaults = {
    codebuild_parameters = {
      image_url     = data.terraform_remote_state.org_prerequisites.outputs.repository_url
      image_version = "20260127113543"
      cb_timeout    = "60"
    }
    action = {
      input_artifacts  = ["buildspec"]
      output_artifacts = []
    }
  }
}
