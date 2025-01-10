#!/usr/bin/env bash

set -euo pipefail


get_token() {
  gsutil cp "gs://${TF_VAR_project}-key/root-token.enc" . > /dev/null 2>&1
}

terraform init -upgrade > /tmp/terraform.log 2>&1

# To solve the bootstrapping problem of creating Vault in CR
# and then being able to apply policies to the Vault instance
# We first run a targeted apply to just the module that creates the Vault server
# but only need to do this once
# and we'll know if it's done if we can't download the encrypted token
get_token || (terraform apply -target=module.vault -auto-approve >> /tmp/terraform.log 2>&1 && get_token)

# fetch the token from KMS and store it in VAULT_TOKEN
base64 -d -i root-token.enc > root-token.dc
gcloud kms decrypt --key=vault --keyring=vault-server --location=global \
  --project="${TF_VAR_project}" \
  --ciphertext-file=root-token.dc \
  --plaintext-file=root-token
export VAULT_TOKEN="$(cat root-token)"

# cleanup
rm root-token root-token.enc root-token.dc

# Now we can apply all of the terraform with a valid Vault token
terraform apply -auto-approve >> /tmp/terraform.log 2>&1 
