resource "vault_mount" "kv_v1" {
  path = "secret"
  type = "kv"

  options = {
    version = 1
  }
}
