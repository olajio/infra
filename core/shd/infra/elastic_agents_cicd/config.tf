#Order of stages is determined by their names, sorted alfabetically. Name stages properly, to achieve desired order.
locals {
  pipeline = {
    stage_name = "s10_${var.solution_name}",
    codebuild = "infrastructure"
  }

  codebuild = {
    infrastructure = {
      codebuild_parameters = merge(local.codebuilds_defaults.codebuild_parameters,
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
    }
    environment_variables = {
      "SOLUTIONS_ROOT" = var.solutions_root
      "SOLUTION_NAME" = var.solution_name
      "SRC_VERSION" = "${var.environment}_${var.solution_name}"
      "ENV" = var.environment
      "CWD" = var.cwd
    }
  }
}
