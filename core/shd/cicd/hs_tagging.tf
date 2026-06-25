module "aws_cb_tags" {
    for_each = local.cb_app_codes
    source  = "../../../modules/hs-tagging/v1.5"
    tagtype = "aws-tags"
    appcode = each.value
    region  = var.region
    env     = var.environment
    name	= "${local.codebuild_name}-${each.key}"
    suffix  = "0000"
}
