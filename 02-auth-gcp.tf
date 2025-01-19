resource "vault_auth_backend" "gcp" {
  path = "gcp"
  type = "gcp"
}

resource "vault_gcp_auth_backend_role" "ghat" {
  backend                = vault_auth_backend.gcp.path
  role                   = "ghat"
  type                   = "iam"
  bound_service_accounts = ["ghat-cr@libops-ghat.iam.gserviceaccount.com"]
  bound_projects         = ["libops-ghat"]
  token_ttl              = 300
  token_max_ttl          = 900
  token_policies = [
    vault_policy.policies["gcp-kv1.hcl"].name
  ]
  add_group_aliases = true
}
