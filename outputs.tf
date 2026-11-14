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

output "proof_common_name" {
  description = "Common name of the proof service token in the Access JWT; npm run deploy sets it as the Worker var ACCESS_PROOF_COMMON_NAME."
  value       = nonsensitive(cloudflare_zero_trust_access_service_token.proof.client_id)
}

output "proof_client_id" {
  sensitive   = true
  description = "CF-Access-Client-Id of the proof service token; npm-scripts/proof-env.mjs passes it to the proof as TUMPEL_PROOF_CLIENT_ID."
  value       = cloudflare_zero_trust_access_service_token.proof.client_id
}

output "proof_client_secret" {
  sensitive   = true
  description = "CF-Access-Client-Secret of the proof service token; npm-scripts/proof-env.mjs passes it to the proof as TUMPEL_PROOF_CLIENT_SECRET."
  value       = cloudflare_zero_trust_access_service_token.proof.client_secret
}

output "worker_secrets" {
  sensitive   = true
  description = "Worker secrets of the stage; the S3 key pair derives from the R2 token: access key id is the token id, secret is the SHA-256 hex of the token value. SECRETS_KEK wraps each tenant's data key for secret values."
  value = {
    R2_ACCOUNT_ID        = var.account_id
    R2_ACCESS_KEY_ID     = cloudflare_account_token.r2.id
    R2_SECRET_ACCESS_KEY = sha256(cloudflare_account_token.r2.value)
    SECRETS_KEK          = random_bytes.secrets_kek.base64
  }
}
