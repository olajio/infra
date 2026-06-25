resource "aws_codebuild_project" "cb_destroy" {
  for_each      = local.codebuilds
  name          = "${local.codebuild_name}-${each.key}-destroy"
  description   = "Code build worker for CICD destroy for env ${var.environment}"
  build_timeout = "60"
  service_role  = local.codebuild_role_arn

  tags = merge(
    {
      Name        = "${local.codebuild_name}-${each.key}-destroy"
      Environment = var.environment
    },
    local.more_tags,
    { for k,v in try(local.cb_extra_tags[each.key]["tags"], {}): k => "${ v == "${local.codebuild_name}-${each.key}" ? "${v}-destroy" : (v)}" }
  )

  vpc_config {
    security_group_ids = [local.codebuil_security_group]
    subnets            = local.subnet_ids
    vpc_id             = local.vpc_id
  }


  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "${each.value.codebuild_parameters["image_url"]}:${each.value.codebuild_parameters["image_version"]}"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = "false"
    image_pull_credentials_type = "SERVICE_ROLE"

    environment_variable {
      name  = "SOLUTIONS_ROOT"
      value = var.solutions_root
    }

    environment_variable {
      name  = "SOLUTION_NAME"
      value = each.key
    }

    environment_variable {
      name  = "SRC_VERSION"
      value = "${var.environment}_${var.cicd_name}"
    }

    environment_variable {
      name  = "ENV"
      value = var.environment
    }

    environment_variable {
      name  = "CWD"
      value = var.cwd
    }

    environment_variable {
      name  = "TF_ACTIONS"
      value = module.tf_actions_destroy.ssm_parameter_name
      type  = "PARAMETER_STORE"
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}
