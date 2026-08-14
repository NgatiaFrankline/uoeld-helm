#!/bin/bash
# Creates the Kubernetes Secret that supplies the Grafana OIDC client_secret.
# The secret is referenced in apps/prometheus-stack/values.yaml via:
#   envFromSecret: grafana-oidc
#   client_secret: $__env{GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET}
#
# Usage:
#   ./create_grafana_oidc_secret.sh <keycloak-client-secret>
#
# Get the secret from:
#   Keycloak > Clients > grafana > Credentials > Client Secret

set -euo pipefail

NAMESPACE="prometheus-stack"
SECRET_NAME="grafana-oidc"
CLIENT_SECRET="${1:-}"

if [[ -z "${CLIENT_SECRET}" ]]; then
  echo "Usage: $0 <keycloak-client-secret>"
  exit 1
fi

kubectl create secret generic "${SECRET_NAME}" \
  --from-literal=GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET="${CLIENT_SECRET}" \
  --namespace "${NAMESPACE}" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Secret '${SECRET_NAME}' created/updated in namespace '${NAMESPACE}'."
