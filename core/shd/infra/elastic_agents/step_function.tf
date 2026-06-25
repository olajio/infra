resource "aws_iam_role_policy" "ec2_on_stepfunc_role_policy" {
  name = "ec2_on_stepfunc_role_policy"
  role = aws_iam_role.ec2_on_stepfunc_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "lambda",
        "Effect" : "Allow",
        "Action" : [
          "lambda:InvokeFunction"
        ],
        "Resource" : "${aws_lambda_function.terraform_lambda_func.arn}:*"
      },
      {
        "Sid" : "parameterstore",
        "Effect" : "Allow",
        "Action" : [
          "ssm:Get*"
        ],
        "Resource" : [aws_ssm_parameter.known_codes.arn, aws_ssm_parameter.unknown_codes.arn]
      },
      {
        "Sid" : "logs",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ],
        "Resource" : "${aws_cloudwatch_log_group.ec2_on_step_func.arn}:*:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogDelivery",
          "logs:CreateLogStream",
          "logs:GetLogDelivery",
          "logs:UpdateLogDelivery",
          "logs:DeleteLogDelivery",
          "logs:ListLogDeliveries",
          "logs:PutLogEvents",
          "logs:PutResourcePolicy",
          "logs:DescribeResourcePolicies",
          "logs:DescribeLogGroups"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2_on_stepfunc_role" {
  name = "ec2_on_stepfunc_role"
  tags = {
    "Name"                      = "ec2_on_stepfunc_role",
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
        Sid       = ""
        Principal = {
          Service = "states.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "ec2_on_flow"
  role_arn = aws_iam_role.ec2_on_stepfunc_role.arn

  definition = <<EOF
{
  "Comment": "Excepts appcode from ec2 and determines if to start codebuild",
  "StartAt": "app-codes_to_ignore",
  "States": {
    "app-codes_to_ignore": {
      "Type": "Task",
      "Parameters": {
        "Name": "app-codes_to_ignore"
      },
      "Resource": "arn:aws:states:::aws-sdk:ssm:getParameter",
      "ResultSelector": {
        "code2ignore.$": "$.Parameter.Value"
      },
      "ResultPath": "$.store",
      "Next": "Lambda Invoke"
    },
    "Lambda Invoke": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "arn:aws:lambda:us-east-2:469620122115:function:millis_since_epoch:$LATEST",
        "Payload": {}
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
            "Lambda.TooManyRequestsException"
          ],
          "IntervalSeconds": 2,
          "MaxAttempts": 6,
          "BackoffRate": 2
        }
      ],
      "Next": "Check if appcode is in ignore list",
      "ResultPath": "$.epoch"
    },
    "Check if appcode is in ignore list": {
      "Type": "Pass",
      "Parameters": {
        "in_ignore_list.$": "States.ArrayContains(States.StringSplit($.store.code2ignore,','), $.detail.configurationItem.tags.['hs:std:app-code'])"
      },
      "Next": "1. ----------IF-----------",
      "ResultPath": "$.check"
    },
    "Check if enviorment var exist": {
      "Type": "Choice",
      "Choices": [
        {
          "Not": {
            "Variable": "$.detail.configurationItem.tags.Environment",
            "IsPresent": true
          },
          "Comment": "Environment field does NOT exist",
          "Next": "Pick Env based on the account id"
        },
        {
          "Variable": "$.detail.configurationItem.tags.Environment",
          "IsPresent": true,
          "Next": "Check if Platform var exists"
        }
      ]
    },
    "Pick Env based on the account id": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.account",
          "StringEquals": "213997214095",
          "Next": "ADD QA ENV",
          "Comment": "QA"
        },
        {
          "Variable": "$.account",
          "StringEquals": "605836930483",
          "Next": "ADD RND ENV",
          "Comment": "RND"
        },
        {
          "Variable": "$.account",
          "StringEquals": "036973397917",
          "Next": "ADD UAT ENV",
          "Comment": "UAT"
        },
        {
          "Variable": "$.account",
          "StringEquals": "818366959089",
          "Next": "ADD TST ENV",
          "Comment": "TST"
        },
        {
          "Variable": "$.account",
          "StringEquals": "469620122115",
          "Next": "ADD SHD ENV",
          "Comment": "SHD"
        },
        {
          "Variable": "$.account",
          "StringEquals": "444205886984",
          "Next": "ADD PRD ENV",
          "Comment": "PRD"
        }
      ]
    },
    "ADD UAT ENV": {
      "Type": "Pass",
      "Next": "Check if Platform var exists",
      "Result": {
        "environment": "UAT"
      },
      "ResultPath": "$.enrichenv"
    },
    "ADD TST ENV": {
      "Type": "Pass",
      "Next": "Check if Platform var exists",
      "Result": {
        "environment": "TST"
      },
      "ResultPath": "$.enrichenv"
    },
    "ADD SHD ENV": {
      "Type": "Pass",
      "Next": "Check if Platform var exists",
      "Result": {
        "environment": "SHD"
      },
      "ResultPath": "$.enrichenv"
    },
    "ADD PRD ENV": {
      "Type": "Pass",
      "Next": "Check if Platform var exists",
      "ResultPath": "$.enrichenv",
      "Result": {
        "environment": "PRD"
      }
    },
    "ADD QA ENV": {
      "Type": "Pass",
      "Next": "Check if Platform var exists",
      "ResultPath": "$.enrichenv",
      "Result": {
        "environment": "QA"
      }
    },
    "Check if Platform var exists": {
      "Type": "Choice",
      "Choices": [
        {
          "Not": {
            "Variable": "$.detail.configurationItem.configuration.platform",
            "IsPresent": true
          },
          "Next": "platform field does not exist",
          "Comment": "Platform Var does NOT exist"
        },
        {
          "Variable": "$.detail.configurationItem.configuration.platform",
          "StringEquals": "windows",
          "Comment": "Platform Var == windows",
          "Next": "Prepair event"
        },
        {
          "Variable": "$.detail.configurationItem.configuration.platform ",
          "StringEquals": "linux",
          "Next": "Prepair event",
          "Comment": "Platform Var == linux"
        }
      ]
    },
    "1. ----------IF-----------": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.check.in_ignore_list",
          "BooleanEquals": true,
          "Next": "AppCode in ignor list"
        },
        {
          "Variable": "$.check.in_ignore_list",
          "BooleanEquals": false,
          "Next": "Check if enviorment var exist"
        }
      ]
    },
    "AppCode in ignor list": {
      "Type": "Pass",
      "Next": "PutLogEvents -> AppCodeInIgnoreList",
      "Parameters": {
        "account.$": "$.account",
        "region.$": "$.region",
        "timestamp.$": "$.time",
        "hostname.$": "$.detail.configurationItem.tags.Name",
        "appcode.$": "$.detail.configurationItem.tags.['hs:std:app-code']"
      },
      "ResultPath": "$.all"
    },
    "PutLogEvents -> AppCodeInIgnoreList": {
      "Type": "Task",
      "End": true,
      "Parameters": {
        "LogEvents": [
          {
            "Message.$": "$.all",
            "Timestamp.$": "$.epoch.Payload"
          }
        ],
        "LogGroupName": "/aws/states/ec2_on_step_func_logs",
        "LogStreamName": "AppCodeInIgnoreList"
      },
      "Resource": "arn:aws:states:::aws-sdk:cloudwatchlogs:putLogEvents",
      "ResultPath": "$.org"
    },
    "app-codes_in_role": {
      "Type": "Task",
      "Parameters": {
        "Name": "app-codes_in_role"
      },
      "Resource": "arn:aws:states:::aws-sdk:ssm:getParameter",
      "ResultPath": "$.store2",
      "ResultSelector": {
        "role_list.$": "$.Parameter.Value"
      },
      "Next": "Check if appcode is in Ansible role list"
    },
    "Check if appcode is in Ansible role list": {
      "Type": "Pass",
      "Next": "---------IF----------",
      "Parameters": {
        "in_role_list.$": "States.ArrayContains(States.StringSplit($.store2.role_list,','), $.appcode)"
      },
      "ResultPath": "$.store1"
    },
    "---------IF----------": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.store1.in_role_list",
          "BooleanEquals": true,
          "Next": "START CODEBUILD"
        },
        {
          "Variable": "$.store1.in_role_list",
          "BooleanEquals": false,
          "Next": "AppCode NOT in Ansible role list"
        }
      ]
    },
    "AppCode NOT in Ansible role list": {
      "Type": "Pass",
      "Next": "PutLogEvents -> AppCodeNOTinRoleList"
    },
    "PutLogEvents -> AppCodeNOTinRoleList": {
      "Type": "Task",
      "End": true,
      "Parameters": {
        "LogEvents": [
          {
            "Message.$": "$",
            "Timestamp.$": "$.time"
          }
        ],
        "LogGroupName": "/aws/states/ec2_on_step_func_logs",
        "LogStreamName": "AppCodeNOTinRoleList"
      },
      "Resource": "arn:aws:states:::aws-sdk:cloudwatchlogs:putLogEvents"
    },
    "START CODEBUILD": {
      "Type": "Pass",
      "Next": "PutLogEvents"
    },
    "PutLogEvents": {
      "Type": "Task",
      "End": true,
      "Parameters": {
        "LogEvents": [
          {
            "Message.$": "$",
            "Timestamp.$": "$.time"
          }
        ],
        "LogGroupName": "/aws/states/ec2_on_step_func_logs",
        "LogStreamName": "CodeBuild"
      },
      "Resource": "arn:aws:states:::aws-sdk:cloudwatchlogs:putLogEvents"
    },
    "ADD RND ENV": {
      "Type": "Pass",
      "Next": "Check if Platform var exists",
      "Result": {
        "environment": "RND"
      },
      "ResultPath": "$.enrichenv"
    },
    "platform field does not exist": {
      "Type": "Pass",
      "Next": "Prepair event",
      "Result": {
        "os": "linux"
      },
      "ResultPath": "$.enrichplatform"
    },
    "Prepair event": {
      "Type": "Choice",
      "Choices": [
        {
          "And": [
            {
              "Not": {
                "Variable": "$.enrichenv.environment",
                "IsPresent": true
              }
            },
            {
              "Not": {
                "Variable": "$.enrichplatform.os",
                "IsPresent": true
              }
            }
          ],
          "Next": "Platform and Enviornment vars in Raw Event",
          "Comment": "RAW EVENT"
        },
        {
          "And": [
            {
              "Variable": "$.enrichenv.environment",
              "IsPresent": true
            },
            {
              "Variable": "$.enrichplatform.os",
              "IsPresent": true
            }
          ],
          "Next": "Missing Platform and Enviornment vars"
        },
        {
          "Variable": "$.enrichplatform.os",
          "IsPresent": true,
          "Next": "Missing Platform var"
        },
        {
          "Variable": "$.enrichenv.environment",
          "IsPresent": true,
          "Next": "Missing Enviornment var"
        }
      ]
    },
    "Platform and Enviornment vars in Raw Event": {
      "Type": "Pass",
      "Next": "app-codes_in_role",
      "Parameters": {
        "elastic_role": "MT",
        "environment.$": "$.detail.configurationItem.tags.Environment",
        "account.$": "$.account",
        "region.$": "$.region",
        "os.$": "$.detail.configurationItem.configuration.platform",
        "list.$": "$.detail.configurationItem.tags.Name",
        "appcode.$": "$.detail.configurationItem.tags.['hs:std:app-code']",
        "time.$": "$.epoch.Payload",
        "ip.$": "$.detail.configurationItem.configuration.privateIpAddress"
      }
    },
    "Missing Platform and Enviornment vars": {
      "Type": "Pass",
      "Next": "app-codes_in_role",
      "Parameters": {
        "elastic_role": "MT",
        "environment.$": "$.enrichenv.environment",
        "account.$": "$.account",
        "region.$": "$.region",
        "os.$": "$.enrichplatform.os",
        "list.$": "$.detail.configurationItem.tags.Name",
        "appcode.$": "$.detail.configurationItem.tags.['hs:std:app-code']",
        "time.$": "$.epoch.Payload",
        "ip.$": "$.detail.configurationItem.configuration.privateIpAddress"
      }
    },
    "Missing Platform var": {
      "Type": "Pass",
      "Next": "app-codes_in_role",
      "Parameters": {
        "elastic_role": "MT",
        "environment.$": "$.detail.configurationItem.tags.Environment",
        "account.$": "$.account",
        "region.$": "$.region",
        "os.$": "$.enrichplatform.os",
        "list.$": "$.detail.configurationItem.tags.Name",
        "appcode.$": "$.detail.configurationItem.tags.['hs:std:app-code']",
        "time.$": "$.epoch.Payload",
        "ip.$": "$.detail.configurationItem.configuration.privateIpAddress"
      }
    },
    "Missing Enviornment var": {
      "Type": "Pass",
      "Next": "app-codes_in_role",
      "Parameters": {
        "elastic_role": "MT",
        "environment.$": "$.enrichenv.environment",
        "account.$": "$.account",
        "region.$": "$.region",
        "os.$": "$.detail.configurationItem.configuration.platform",
        "list.$": "$.detail.configurationItem.tags.Name",
        "appcode.$": "$.detail.configurationItem.tags.['hs:std:app-code']",
        "time.$": "$.epoch.Payload",
        "ip.$": "$.detail.configurationItem.configuration.privateIpAddress"
      }
    }
  }
}
EOF
  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.ec2_on_step_func_error.arn}:*"
    include_execution_data = false
    level                  = "ERROR"
  }
  depends_on = [aws_cloudwatch_log_group.ec2_on_step_func]
}

