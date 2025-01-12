path "secret/{{identity.entity.metadata.project_id}}/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
