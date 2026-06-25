
terraform {
  backend "s3" {
    bucket     = "hedgeserv-shd-lz-us-east-2-s3-tf-state"
    key        = "core/shd/cicd/terraform.tfstate"
    kms_key_id = "alias/hedgeserv-shd-lz-us-east-2-s3-tf-state-kms-key"
    encrypt    = true
    region     = "us-east-2"
  }
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_organizations_organization" "current" {}

# Landing Zone states

data "terraform_remote_state" "org_accounts_bootstrap" {
  backend = "s3"
  config = {
    bucket = "hedgeserv-org-tf-us-east-2-s3-state"
    key    = "lz/ou/core/org/solutions/accounts_bootstrap/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "org_deployment_roles" {
  backend = "s3"
  config = {
    bucket = "hedgeserv-org-tf-us-east-2-s3-state"
    key    = "lz/ou/core/org/solutions/deployment_roles/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "org_networking" {
  backend = "s3"
  config = {
    bucket = "hedgeserv-org-tf-us-east-2-s3-state"
    key    = "lz/ou/core/org/solutions/networking/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "shd_bootstrap" {
  backend = "s3"
  config = {
    bucket = "hedgeserv-org-tf-us-east-2-s3-state"
    key    = "lz/ou/core/org/solutions/accounts_bootstrap/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "org_prerequisites" {
  backend = "s3"
  config = {
    bucket = "hedgeserv-org-tf-us-east-2-s3-state"
    key    = "lz/ou/core/org/prerequisites/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "lz_adfs_account_roles" {
  backend = "s3"
  config = {
    bucket = "hedgeserv-org-tf-us-east-2-s3-state"
    key    = "lz/ou/core/org/solutions/adfs_account_roles/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "image_factory_platform_terraform" {
  backend = "s3"
  config = {
    bucket = "hedgeserv-shd-lz-us-east-2-s3-tf-state"
    key    = "core/shd/infra/image_factories/infra_image_factory_platform-terraform/terraform.tfstate"
    region = "us-east-2"
  }
}
