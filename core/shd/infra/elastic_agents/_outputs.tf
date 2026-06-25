output "ADF_apigw_tokens" {
  value = module.secrets_manager_alarm_decision_framework_shd.secret
}

output "ADF_apigw_dyndb_amdb_tokens" {
  value = module.secrets_manager_alarm_decision_framework_api_update_shd.secret
}