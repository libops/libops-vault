locals {
  policy_files = fileset("policies", "*.hcl")
}

data "local_file" "policy_docs" {
  for_each = local.policy_files
  filename = "policies/${each.value}"
}

resource "vault_policy" "policies" {
  for_each = data.local_file.policy_docs

  name   = basename(replace(each.value.filename, ".hcl", ""))
  policy = each.value.content
}
