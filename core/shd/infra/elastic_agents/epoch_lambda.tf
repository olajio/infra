data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_epoch_lambda" {
  name               = "iam_for_epoch_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = {
    "Name"                      = "millis_since_epoch",
    "Env"                       = var.environment,
    "Region"                    = local.region,
    "hs:std:app-code"           = "MT2ELK",
    "hs:std:app-name"           = "EC2EventOn",
    "hs:std:description"        = "Provides Epoch timestamp for CloudWatch Log Group",
    "hs:std:svc-operator"       = "ITSMA",
    "hs:std:svc-software-owner" = "ITSMA"
  }
}

resource "null_resource" "lambda_exporter" {
  triggers = {
    always_apply = timestamp()
  }

  provisioner "local-exec" {
    command = <<-COMMANDS
       echo "trigger lambda"
    COMMANDS
  }
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_file = "${path.module}/script/millis_since_epoch.py"
  output_path = "/tmp/script_python.zip"
  depends_on  = [null_resource.lambda_exporter]
}

resource "aws_lambda_function" "terraform_lambda_func" {
  filename         = data.archive_file.zip_the_python_code.output_path
  function_name    = "millis_since_epoch"
  description      = "Lambda returns the current time in millis(format) since epoch. As requested by cloudwatch log groups"
  role             = aws_iam_role.iam_for_epoch_lambda.arn
  handler          = "millis_since_epoch.lambda_handler"
  runtime          = "python3.11"
  timeout          = "30"
  source_code_hash = data.archive_file.zip_the_python_code.output_base64sha256
  depends_on = [data.archive_file.zip_the_python_code]

  tags = {
    "Name"                      = "millis_since_epoch",
    "Env"                       = var.environment,
    "Region"                    = local.region,
    "hs:std:app-code"           = "MT2ELK",
    "hs:std:app-name"           = "EC2EventOn",
    "hs:std:description"        = "Provides Epoch timestamp for CloudWatch Log Group",
    "hs:std:svc-operator"       = "ITSMA",
    "hs:std:svc-software-owner" = "ITSMA"
  }
}