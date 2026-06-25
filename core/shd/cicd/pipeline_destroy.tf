resource "aws_codepipeline" "infra_pipeline_destroy" {
  name     = "${local.codepipeline_name}-destroy"
  role_arn = local.codepipeline_role_arn

  artifact_store {
    location = local.artifacts_s3_name
    type     = "S3"

    encryption_key {
      id   = local.artifacts_s3_kms_id
      type = "KMS"
    }
  }

  stage {
    name = "getSource"

    action {
      category         = "Source"
      name             = "getBuildspec"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["buildspec"]

      configuration = {
        S3Bucket             = local.artifacts_s3_name
        S3ObjectKey          = aws_s3_bucket_object.buildspec.key
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "You_must_be_sure"
    action {
      category = "Approval"
      name     = "destroy_approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        CustomData = "THIS WILL DESTROY ALL INFRA IN THE ${upper(var.environment)} ACCOUNT"
      }
    }
  }

  dynamic "stage" {
    for_each = { for i, k in reverse(sort(keys(local.pipeline))) : replace(k, "/^s[0-9]*_/", "d${(i + 1) * 10}_") => local.pipeline[k] }
    content {
      name = stage.key

      dynamic "action" {
        for_each = toset(stage.value)
        content {
          name             = action.value
          category         = "Build"
          owner            = "AWS"
          provider         = "CodeBuild"
          version          = "1"
          input_artifacts  = local.codebuilds[action.value]["action"]["input_artifacts"]
          output_artifacts = local.codebuilds[action.value]["action"]["output_artifacts"]
          configuration = {
            ProjectName = aws_codebuild_project.cb_destroy[action.value].name
          }
        }
      }
    }
  }


  tags = merge(
    {
      Name        = local.codepipeline_name
      Environment = var.environment
    },
    local.more_tags
  )
}
