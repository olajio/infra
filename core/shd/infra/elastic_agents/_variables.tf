 variable "ssm_path" {
   default = "/shd/elastic-agents"
 }

 variable "cb_runtime_image" {
   description = "The docker image that will be used by codebuild to start."
   type        = string
   default     = ""
 }

 variable "cb_runtime_image_name_sfx" {
   description = "The docker image suffix that will be used by codebuild to start."
   type        = string
   default     = ""
 }

 variable "cb_runtime_image_name" {
   description = "The docker image that will be used by codebuild to start."
   type        = string
   default     = ""
 }

 variable "cb_runtime_version" {
   description = "The docker image version that will be by codebuild to start."
   type        = string
   default     = "latest"
 }

 variable "cb_runtime_envs" {
   description = "The docker image runtime environemnt variables."
   type        = map(string)
   default     = {}
 }

 variable "cb_role_name" {
   description = "The role name that will compose the arn and passed to the codebuild."
   type        = string
   default     = "InfrastructureCodeBuildCustomServiceRole"
 }

 variable "cb_name_sfx" {
   description = "Codebuild name suffix, it will be added to the naming_prefix. Default is to extract it from the folder name."
   type        = string
   default     = ""
 }

 variable "cb_name" {
   description = "Codebuild name. Default is to compose it from naming_prefix+cb_name_sfx"
   type        = string
   default     = ""
 }

 variable "cb_credentials_type" {
   description = "Set image_pull_credential_type to either CODEBUILD (standard image) or SERVICE_ROLE (custom image)"
   default     = "SERVICE_ROLE"
 }

 variable "org_id" {
   description = "Organization id. Default is to take it with tf data."
   type        = string
   default     = ""
 }

 variable "region" {
   description = "AWS region. Default is to take it with tf data."
   type        = string
   default     = ""
 }

 variable "region_ohio" {
   description = "AWS region. Default is ohio."
   type        = string
   default     = "us-east-2"
 }

 variable "region_virginia" {
   description = "Secondary AWS region. Default is to take it with tf data."
   type        = string
   default     = "us-east-1"
 }

 variable "account_id" {
   description = "Account ID. Default is to take it with tf data."
   type        = string
   default     = ""
 }

 variable "naming_prefix" {
   description = "The prefix that will be used for all resources created. Default is ou_environment_component_region."
   type        = string
   default     = ""
 }

 variable "ou" {
   description = "Project name or abbreviation"
   type        = string
   default     = "core"
 }

 variable "environment" {
   description = "Environment name or abbreviation"
   type        = string
   default     = "shd"
 }

 variable "component" {
   description = "Module name or abbreviation"
   type        = string
   default     = ""
 }

 variable "owner" {
   description = "Owner of the resource"
   default     = "aws_itsma"
 }
