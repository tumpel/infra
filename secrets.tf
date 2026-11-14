resource "random_bytes" "secrets_kek" {
  length = 32

  lifecycle {
    prevent_destroy = true
  }
}
