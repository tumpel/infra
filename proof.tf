resource "cloudflare_zero_trust_access_service_token" "proof" {
  provider   = cloudflare.bootstrap
  account_id = var.account_id
  name       = "tumpel-proof-${var.stage}"
  duration   = "8760h"
}

resource "cloudflare_zero_trust_access_policy" "proof" {
  account_id = var.account_id
  name       = "tumpel proof ${var.stage}"
  decision   = "non_identity"
  include = [{
    service_token = {
      token_id = cloudflare_zero_trust_access_service_token.proof.id
    }
  }]
}
