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
  value = local.api_hostname
}

output "dashboard_hostname" {
  value = local.dashboard_hostname
}

output "issuer_hostname" {
  value = local.issuer_hostname
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
  description = "Worker secrets of the stage; the S3 key pair derives from the R2 token: access key id is the token id, secret is the SHA-256 hex of the token value. RELEASES_ACCESS_KEY_ID and RELEASES_SECRET_ACCESS_KEY derive the same way from the read-only token of the release bucket. SECRETS_KEK wraps each tenant's data key for secret values. VAPID_PRIVATE_KEY signs Web Push requests. METRICS_READ_TOKEN holds Account Analytics Read alone and queries Workers Analytics Engine in METRICS_ACCOUNT_ID."
  value = {
    R2_ACCOUNT_ID              = var.account_id
    R2_ACCESS_KEY_ID           = cloudflare_account_token.r2.id
    R2_SECRET_ACCESS_KEY       = sha256(cloudflare_account_token.r2.value)
    SECRETS_KEK                = random_bytes.secrets_kek.base64
    RELEASES_ACCESS_KEY_ID     = cloudflare_account_token.releases_read.id
    RELEASES_SECRET_ACCESS_KEY = sha256(cloudflare_account_token.releases_read.value)
    VAPID_PRIVATE_KEY          = tls_private_key.vapid.private_key_pem_pkcs8
    METRICS_READ_TOKEN         = cloudflare_account_token.metrics_read.value
    METRICS_ACCOUNT_ID         = var.account_id
  }
}

output "vapid_public_key" {
  description = "PEM-encoded P-256 public key for Web Push subscriptions."
  value       = tls_private_key.vapid.public_key_pem
}

output "releases_bucket" {
  description = "R2 bucket the release workflow uploads to: supervisor/<arch>/<sha256>, images/<harness>/<harnessVersion>/<arch>/<digest>, kernels/<arch>/<sha256>, and current.json last."
  value       = cloudflare_r2_bucket.releases.name
}

output "cloudflare_account_id" {
  description = "Account of the release bucket; the release workflow reads it as the repository secret CLOUDFLARE_ACCOUNT_ID."
  value       = var.account_id
}

output "r2_releases_access_key_id" {
  sensitive   = true
  description = "S3 access key id of tumpel-releases-upload-<stage>, Object Read & Write on the release bucket alone: the token id. Repository secret R2_RELEASES_ACCESS_KEY_ID; npm run release:secrets sets it."
  value       = cloudflare_account_token.releases_upload.id
}

output "r2_releases_secret_access_key" {
  sensitive   = true
  description = "S3 secret access key of tumpel-releases-upload-<stage>: the SHA-256 hex of the token value. Repository secret R2_RELEASES_SECRET_ACCESS_KEY; npm run release:secrets sets it."
  value       = sha256(cloudflare_account_token.releases_upload.value)
}

output "releases_queue" {
  description = "Queue that receives the release bucket's current.json writes after a delay past the release cache; the control plane consumes it and sends every Online host ReleasePublished."
  value       = cloudflare_queue.releases.queue_name
}
