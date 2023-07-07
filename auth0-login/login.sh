#!/bin/bash

set -euo pipefail

# get a JWT access token from Auth0
token_request() {
  cat <<JSON
{
  "client_id": "$AUTH0_CLIENT_ID",
  "client_secret": "$AUTH0_CLIENT_SECRET",
  "audience": "$AUTH0_AUDIENCE",
  "grant_type": "client_credentials"
}
JSON
}
token=$(curl -fsS \
  -H "Content-Type: application/json" \
  --data "$(token_request)" \
  "https://$AUTH0_DOMAIN/oauth/token" \
  | jq -r '.access_token')

# set the token as a secret and export it
echo "::add-mask::$token"
echo "token=$token" >> "$GITHUB_OUTPUT"
