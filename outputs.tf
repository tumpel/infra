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
