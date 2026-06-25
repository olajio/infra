data "archive_file" "buildspec" {
  output_path = "buildspec_${var.solution_name}.zip"
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

  stage {
    name = "Plan"

    action {
      category         = "Build"
      name             = "${local.codebuild_name}-plan"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["buildspec"]
      output_artifacts = ["tfplan"]

      configuration = {
        ProjectName = aws_codebuild_project.cb_plan.name
      }
    }
  }

  stage {
    name = "approval"

    action {
      name      = "Terraform-Plan-Review-ApproveOrReject"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      version   = "1"
      run_order = "1"
    }
  }

  stage {
    name = "Apply"

    action {
      category         = "Build"
      name             = "${local.codebuild_name}-apply"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["buildspec","tfplan"]

      configuration   = {
        ProjectName   = aws_codebuild_project.cb_apply.name
        PrimarySource = "buildspec"
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
