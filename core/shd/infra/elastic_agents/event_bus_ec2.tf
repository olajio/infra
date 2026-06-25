resource "aws_cloudwatch_event_rule" "capture_ec2_on_events" {
  name        = "ec2_on_events"
  description = "Capture when a new EC2 instance has been lunched"

  event_pattern = jsonencode({
    "source" : ["aws.config"],
    "detail-type" : ["Config Configuration Item Change"],
    "detail" : {
      "messageType" : ["ConfigurationItemChangeNotification"],
      "configurationItem" : {
        "resourceType" : ["AWS::EC2::Instance"],
        "configurationItemStatus" : ["ResourceDiscovered"]
      }
    }
  })
}
#---------------------------EventBridge RULE - Cloudwatch Log Group Target------------------------------------
resource "aws_cloudwatch_log_group" "ec2_on_events" {
  name              = "/aws/events/ec2_on_events_logs"
  retention_in_days = 5
}

resource "aws_cloudwatch_event_target" "cloudwatch_group" {
  rule = aws_cloudwatch_event_rule.capture_ec2_on_events.name
  arn  = aws_cloudwatch_log_group.ec2_on_events.arn
}

data "aws_iam_policy_document" "events-log-publishing-policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = ["${aws_cloudwatch_log_group.ec2_on_events.arn}:*"]

    principals {
      identifiers = ["events.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "events-log-publishing-policy" {
  policy_document = data.aws_iam_policy_document.events-log-publishing-policy.json
  policy_name     = "events-log-publishing-policy"
}
#-----------------------------------------EventBridge RULE - Step Function Targets----------------------------------------

resource "aws_cloudwatch_event_target" "step_function_ec2_on_flow" {
  rule     = aws_cloudwatch_event_rule.capture_ec2_on_events.name
  arn      = aws_sfn_state_machine.sfn_state_machine.arn
  role_arn = aws_iam_role.event_bridge_step_function_target.arn
}

resource "aws_iam_role_policy" "event_bridge_step_fun_target" {
  name = "ec2_on_stepfunc_role_policy"
  role = aws_iam_role.event_bridge_step_function_target.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "StepFunctionRuleTarget",
        "Effect" : "Allow",
        "Action" : [
          "states:StartExecution"
        ],
        "Resource" : aws_sfn_state_machine.sfn_state_machine.arn
      }
    ]
  })
}

resource "aws_iam_role" "event_bridge_step_function_target" {
  name = "event_bridge_step_function_target_role"
  tags = {
    "Name"                      = "event_bridge_step_function_target_role",
    "Env"                       = var.environment,
    "Region"                    = local.region,
    "hs:std:svc-operator"       = "ITSMA",
    "hs:std:svc-software-owner" = "ITSMA"
  }
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = "EventBridgeStepFunctionTargetRole"
        Principal = {
          Service = "events.amazonaws.com"
        }
      },
    ]
  })
}


#-------------------------------------Conf policy on the event bus ----------------------------------

data "aws_iam_policy_document" "default_event_bus" {
  statement {
    sid     = "OrgPathAccess"
    effect  = "Allow"
    actions = [
      "events:PutEvents",
    ]
    resources = [
      "arn:aws:events:us-east-2:469620122115:event-bus/default"
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:PrincipalOrgPaths"
      values   = local.cross_account_event_bus_ou_paths
    }
  }
}

resource "aws_cloudwatch_event_bus_policy" "default_event_bus" {
  policy         = data.aws_iam_policy_document.default_event_bus.json
  event_bus_name = "default"
}