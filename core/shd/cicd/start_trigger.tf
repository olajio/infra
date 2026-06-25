module "cloudwatch_event_rule_start_trigger_tags" {
  source  = "../../../modules/hs-tagging/v1.5"
  tagtype = "aws-tags"
  appcode = var.appcode_cicd
  region  = local.region
  env     = var.environment
  name	  = local.start_trigger_cw_event_rule
  suffix  = "0000"
}

resource "aws_cloudwatch_event_rule" "start_trigger" {
  event_pattern = templatefile("${path.module}/policies/start_trigger_event_pattern.json", {
    env = var.environment
  })
  name        = local.start_trigger_cw_event_rule
  description = "Start cicd-pipeline after bootstrap is over with success"
  tags = merge(
    {
      Name        = local.start_trigger_cw_event_rule
      Environment = var.environment
    },
    module.cloudwatch_event_rule_start_trigger_tags.tags
  )
}

resource "aws_cloudwatch_event_target" "start_trigger" {
  target_id = "cicd-pipeline"
  arn       = aws_codepipeline.pipeline.arn
  rule      = aws_cloudwatch_event_rule.start_trigger.name
  role_arn  = aws_iam_role.start_trigger.arn
}

resource "aws_iam_role" "start_trigger" {
  name               = "${local.naming_prefix}-iamr-start-trigger"
  assume_role_policy = templatefile("${path.module}/policies/start_trigger_assume_role_policy.json", {})
}

resource "aws_iam_role_policy_attachment" "start_trigger" {
  policy_arn = aws_iam_policy.start_trigger.arn
  role       = aws_iam_role.start_trigger.name
}

resource "aws_iam_policy" "start_trigger" {
  name = "${local.naming_prefix}-iamp-start-trigger"
  policy = templatefile("${path.module}/policies/start_trigger_policy.json", {
    cicd_pipeline_arn = aws_codepipeline.pipeline.arn
  })
}
