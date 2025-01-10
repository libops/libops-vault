resource "vault_mount" "kv_v1" {
  path = "kv-v1"
  type = "kv"

  options = {
    version = 1
  }
}
