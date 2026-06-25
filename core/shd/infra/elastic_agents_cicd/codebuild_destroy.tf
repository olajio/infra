resource "aws_codebuild_project" "cb_plan_destroy" {
  name          = "${local.codebuild_name}-plan-destroy"
  description   = "Code build worker for CICD for env ${var.environment}"
  build_timeout = "120"
  service_role  = local.codebuild_role_arn

  tags = merge(
    {
      Name        = "${local.codebuild_name}-plan-destroy"
      Environment = var.environment
    },
    local.more_tags
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
    image                       = "${local.codebuild.infrastructure["codebuild_parameters"]["image_url"]}:${local.codebuild.infrastructure["codebuild_parameters"]["image_version"]}"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = "false"
    image_pull_credentials_type = "SERVICE_ROLE"


    dynamic "environment_variable" {
      for_each = local.codebuilds_defaults.environment_variables
      content {
        name  = environment_variable.key
        value = environment_variable.value 
      }
    }
    environment_variable {
      name  = "TF_ACTIONS"
      value = "all_plan_destroy"
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}

resource "aws_codebuild_project" "cb_apply_destroy" {
  name          = "${local.codebuild_name}-apply-destroy"
  description   = "Code build worker for CICD for env ${var.environment}"
  build_timeout = "120"
  service_role  = local.codebuild_role_arn

  tags = merge(
    {
      Name        = "${local.codebuild_name}-apply"
      Environment = var.environment
    },
    local.more_tags
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
    image                       = "${local.codebuild.infrastructure["codebuild_parameters"]["image_url"]}:${local.codebuild.infrastructure["codebuild_parameters"]["image_version"]}"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = "false"
    image_pull_credentials_type = "SERVICE_ROLE"

    dynamic "environment_variable" {
      for_each = local.codebuilds_defaults.environment_variables
      content {
        name  = environment_variable.key
        value = environment_variable.value 
      }
    }
    environment_variable {
      name  = "TF_ACTIONS"
      value = "all_destroy"
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}
