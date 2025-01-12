#!/usr/bin/env bash

set -euo pipefail

ROLE="${1:-admin}"
ID_TOKEN="${2:-$(gcloud auth print-identity-token)}"

export VAULT_TOKEN=$(vault write -format=json "auth/jwt/login" \
  role="$ROLE" \
  jwt="$ID_TOKEN" \
| jq -r .auth.client_token)

terraform init -upgrade
if [ "$ROLE" = "ci" ]; then
  terraform apply -auto-approve
else
  terraform apply
fi
