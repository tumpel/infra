output "d1_database_id" {
  value = cloudflare_d1_database.tumpel.id
}

output "access_issuer" {
  value = "https://${data.cloudflare_zero_trust_organization.this.auth_domain}"
}

output "access_aud" {
  value = cloudflare_zero_trust_access_application.browser.aud
}

output "hostname" {
  value = var.hostname
}

output "sessions_bucket" {
  value = cloudflare_r2_bucket.sessions.name
}

output "worker_secrets" {
  sensitive   = true
  description = "Worker secrets of the stage; the S3 key pair derives from the R2 token: access key id is the token id, secret is the SHA-256 hex of the token value."
  value = {
    R2_ACCOUNT_ID        = var.account_id
    R2_ACCESS_KEY_ID     = cloudflare_account_token.r2.id
    R2_SECRET_ACCESS_KEY = sha256(cloudflare_account_token.r2.value)
  }
}
