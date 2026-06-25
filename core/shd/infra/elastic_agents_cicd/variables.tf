variable "build_image_credentials" {
  description = "Docker image used in codebuild itself"
  default     = "SERVICE_ROLE"
}

variable "solution_name" {
  description = "Name of the solution"
}

variable "solutions_root" {
  description = "Realtive path to solutions root folder"
}

variable "codepipeline_name" {
  description = "Name of the CodePipeline project"
  default     = ""
}

variable "codebuild_name" {
  description = "Name of the CodeBuild project"
  default     = ""
}

variable "git_pull_enable" {
  description = "Whether the repo will be pulled or webhooks will be used for a push on a change"
  default     = false
}

variable "more_tags" {
  description = "Apply more tags to the solution"
  type        = map(string)
  default     = {}
}

variable "org_id" {
  description = "Organization id"
  default     = ""
}

variable "region" {
  description = "AWS Region"
  default     = "us-east-2"
}

variable "account_id" {
  description = "Account ID"
  default     = ""
}

variable "ou" {
  description = "Project name or abbreviation"
  default     = ""
}

variable "environment" {
  description = "Environment name or abbreviation"
  default     = ""
}

variable "component" {
  description = "Module name or abbreviation"
  default     = ""
}

variable "naming_prefix" {
  description = "The prefix that will be used for all resources created. Default to project-environment-region-module-"
  default     = ""
}

variable "cwd" {
  description = "Path from repository root"
}
