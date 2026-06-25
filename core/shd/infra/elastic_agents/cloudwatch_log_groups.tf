resource "aws_cloudwatch_log_group" "ec2_on_step_func" {
  name              = "/aws/states/ec2_on_step_func_logs"
  retention_in_days = 5
}

resource "aws_cloudwatch_log_stream" "AppCodeInIgnoreList" {
  name           = "AppCodeInIgnoreList"
  log_group_name = aws_cloudwatch_log_group.ec2_on_step_func.name
}

resource "aws_cloudwatch_log_stream" "AppCodeNOTinRoleList" {
  name           = "AppCodeNOTinRoleList"
  log_group_name = aws_cloudwatch_log_group.ec2_on_step_func.name
}

resource "aws_cloudwatch_log_stream" "CodeBuild" {
  name           = "CodeBuild"
  log_group_name = aws_cloudwatch_log_group.ec2_on_step_func.name
}
#------------------------------For Step Function Error logs---------------------------------------
resource "aws_cloudwatch_log_group" "ec2_on_step_func_error" {
  name              = "/aws/states/ec2_on_step_func_error_logs"
  retention_in_days = 5
}