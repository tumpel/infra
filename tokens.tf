data "cloudflare_account_api_token_permission_groups_list" "r2_item_write" {
  provider   = cloudflare.bootstrap
  account_id = var.account_id
  name       = "Workers R2 Storage Bucket Item Write"
}

resource "cloudflare_account_token" "r2" {
  provider   = cloudflare.bootstrap
  account_id = var.account_id
  name       = "tumpel-r2-${var.stage}"

  policies = [
    {
      effect            = "allow"
      resources         = jsonencode({ "com.cloudflare.edge.r2.bucket.${var.account_id}_default_${cloudflare_r2_bucket.sessions.name}" = "*" })
      permission_groups = [{ id = one(data.cloudflare_account_api_token_permission_groups_list.r2_item_write.result).id }]
    },
  ]
}
