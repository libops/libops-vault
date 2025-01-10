# allow GCP auth access to paths in the GSA's project
# https://developer.hashicorp.com/vault/api-docs/auth/gcp#sample-payload-5
resource "vault_policy" "project-read-kv" {
  name = "kv-v1-per-project"

  policy = <<-EOT
    path "kv-v1/{{identity.entity.metadata.project_id}}/*" {
      capabilities = ["create", "read", "update", "delete", "list"]
    }
  EOT
}
