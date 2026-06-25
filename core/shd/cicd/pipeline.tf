data "archive_file" "buildspec" {
  output_path = "buildspec_${var.cicd_name}.zip"
  type        = "zip"
  source_file = "${path.module}/buildspec.yml"
}

resource "aws_s3_bucket_object" "buildspec" {
  key            = data.archive_file.buildspec.output_path
  bucket         = local.artifacts_s3_name
  kms_key_id     = local.artifacts_s3_kms_arn
  content_base64 = filebase64(data.archive_file.buildspec.output_path)
}

resource "aws_codepipeline" "pipeline" {
  name     = local.codepipeline_name
  role_arn = local.codepipeline_role_arn

  artifact_store {
    location = local.artifacts_s3_name
    type     = "S3"

    encryption_key {
      id   = local.artifacts_s3_kms_arn
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

  dynamic "stage" {
    for_each = local.pipeline
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
            ProjectName = aws_codebuild_project.cb[action.value].name
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
