locals {
  browser_paths = ["/device", "/v1/tenants", "/v1/device/approve", "/v1/device/deny", "/oauth/consent"]
}

data "cloudflare_zero_trust_organization" "this" {
  account_id = var.account_id
}

resource "cloudflare_d1_database" "tumpel" {
  account_id            = var.account_id
  name                  = "tumpel"
  primary_location_hint = "weur"

  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_zero_trust_access_policy" "approvers" {
  account_id = var.account_id
  name       = "tumpel approvers"
  decision   = "allow"
  include    = [for email in distinct([for email in var.approver_emails : lower(email)]) : { email = { email = email } }]
}

resource "cloudflare_zero_trust_access_application" "browser" {
  account_id                = var.account_id
  name                      = "tumpel browser pages"
  type                      = "self_hosted"
  session_duration          = "24h"
  app_launcher_visible      = false
  allowed_idps              = [var.otp_idp_id]
  auto_redirect_to_identity = true
  destinations              = [for path in local.browser_paths : { type = "public", uri = "${var.hostname}${path}" }]
  policies = [
    {
      id         = cloudflare_zero_trust_access_policy.approvers.id
      precedence = 1
    }
  ]
}

resource "cloudflare_r2_bucket" "sessions" {
  account_id = var.account_id
  name       = "tumpel-sessions"
  location   = "weur"

  lifecycle {
    prevent_destroy = true
  }
}
