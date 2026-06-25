resource "aws_codebuild_project" "cb" {
  for_each      = local.codebuilds
  name          = "${local.codebuild_name}-${each.key}"
  description   = "Code build worker for CICD for env ${var.environment}"
  build_timeout = each.value.codebuild_parameters["cb_timeout"]
  service_role  = local.codebuild_role_arn

  tags = merge(
    {
      Name        = "${local.codebuild_name}-${each.key}"
      Environment = var.environment
    },
    local.more_tags,
    try(local.cb_extra_tags[each.key]["tags"], {})
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
      value = module.tf_actions.ssm_parameter_name
      type  = "PARAMETER_STORE"
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}
