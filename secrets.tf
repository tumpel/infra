resource "random_bytes" "secrets_kek" {
  length = 32

  lifecycle {
    prevent_destroy = true
  }
}

resource "tls_private_key" "vapid" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"

  lifecycle {
    prevent_destroy = true
  }
}
