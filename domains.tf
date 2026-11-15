locals {
  stage_prefix    = var.stage == "prod" ? "" : "${var.stage}."
  api_hostname    = "api.${local.stage_prefix}${var.zone_name}"
  app_hostname    = "app.${local.stage_prefix}${var.zone_name}"
  issuer_hostname = "id.${local.stage_prefix}${var.zone_name}"
}

data "cloudflare_zone" "this" {
  provider = cloudflare.bootstrap
  filter = {
    name    = var.zone_name
    account = { id = var.account_id }
  }
}

resource "cloudflare_workers_custom_domain" "api" {
  provider   = cloudflare.bootstrap
  account_id = var.account_id
  zone_id    = data.cloudflare_zone.this.id
  hostname   = local.api_hostname
  service    = "tumpel-control-plane-${var.stage}"
}

resource "cloudflare_workers_custom_domain" "app" {
  provider   = cloudflare.bootstrap
  account_id = var.account_id
  zone_id    = data.cloudflare_zone.this.id
  hostname   = local.app_hostname
  service    = "tumpel-dashboard-${var.stage}"
}

resource "cloudflare_dns_record" "issuer" {
  provider = cloudflare.bootstrap
  zone_id  = data.cloudflare_zone.this.id
  name     = local.issuer_hostname
  type     = "AAAA"
  content  = "100::"
  proxied  = true
  ttl      = 1
  comment  = "Reserved as the tumpel ${var.stage} issuer; never rename once tenants pin it. Serves nothing yet."

  lifecycle {
    prevent_destroy = true
  }
}
