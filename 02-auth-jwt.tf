resource "vault_jwt_auth_backend" "gsuite" {
  path               = "jwt"
  oidc_discovery_url = "https://accounts.google.com"
  bound_issuer       = "https://accounts.google.com"
  default_role       = "default"
}

resource "vault_jwt_auth_backend_role" "admin" {
  backend    = vault_jwt_auth_backend.gsuite.path
  role_type  = "jwt"
  role_name  = "admin"
  user_claim = "email"
  bound_audiences = [
    "32555940559.apps.googleusercontent.com"
  ]
  bound_claims = {
    email = "joe@libops.io"
  }
  token_policies = [
    vault_policy.policies["admin.hcl"].name,
    vault_policy.policies["ci.hcl"].name
  ]
}

resource "vault_jwt_auth_backend_role" "ci" {
  backend    = vault_jwt_auth_backend.gsuite.path
  role_type  = "jwt"
  role_name  = "ci"
  user_claim = "email"
  bound_audiences = [
    "vault/ci"
  ]
  bound_claims = {
    email = local.ci_gsa
  }
  token_policies = [
    vault_policy.policies["ci.hcl"].name
  ]
}
