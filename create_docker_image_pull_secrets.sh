#!/bin/bash
set -e

usage() {
  echo "Usage: $0 -u DOCKER_USER -p DOCKER_PASSWORD -e DOCKER_EMAIL -n NAMESPACE"
  echo "  -u   Docker Hub username"
  echo "  -p   Docker Hub password (or personal access token)"
  echo "  -e   Docker Hub email"
  echo "  -n   Kubernetes namespace where the secret will be created"
  exit 1
}

# Parse command line arguments
while getopts "u:p:e:n:" opt; do
  case $opt in
    u) DOCKER_USER="$OPTARG" ;;
    p) DOCKER_PASSWORD="$OPTARG" ;;
    e) DOCKER_EMAIL="$OPTARG" ;;
    n) NAMESPACE="$OPTARG" ;;
    *) usage ;;
  esac
done

# Prompt for any missing values
if [ -z "$DOCKER_USER" ]; then
  read -r -p "Docker Hub username: " DOCKER_USER
fi
if [ -z "$DOCKER_PASSWORD" ]; then
  read -r -s -p "Docker Hub password (or personal access token): " DOCKER_PASSWORD
  echo
fi
if [ -z "$DOCKER_EMAIL" ]; then
  read -r -p "Docker Hub email: " DOCKER_EMAIL
fi
if [ -z "$NAMESPACE" ]; then
  read -r -p "Kubernetes namespace: " NAMESPACE
fi

# Check that all required values are now set
if [ -z "$DOCKER_USER" ] || [ -z "$DOCKER_PASSWORD" ] || [ -z "$DOCKER_EMAIL" ] || [ -z "$NAMESPACE" ]; then
  echo "Error: Missing required value(s)."
  usage
fi

DOCKER_REGISTRY_SERVER="docker.io"

echo
echo "=== Please review the inputs ==="
echo "  Registry server : ${DOCKER_REGISTRY_SERVER}"
echo "  Username        : ${DOCKER_USER}"
echo "  Password        : ${DOCKER_PASSWORD}"
echo "  Email           : ${DOCKER_EMAIL}"
echo "  Namespace       : ${NAMESPACE}"
echo "================================"
echo
read -r -p "Proceed with creating the secret? [y/N] " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

echo
echo "=== Dry-run output ==="
kubectl --namespace "${NAMESPACE}" create secret docker-registry "${NAMESPACE}-docker-repo-key" \
  --docker-server="${DOCKER_REGISTRY_SERVER}" \
  --docker-username="${DOCKER_USER}" \
  --docker-password="${DOCKER_PASSWORD}" \
  --docker-email="${DOCKER_EMAIL}" \
  --dry-run=client -o yaml
echo "======================"
echo
read -r -p "Dry-run looks good? Apply for real? [y/N] " APPLY
if [[ ! "$APPLY" =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

echo
echo "Creating the secret..."
kubectl --namespace "${NAMESPACE}" create secret docker-registry "${NAMESPACE}-docker-repo-key" \
  --docker-server="${DOCKER_REGISTRY_SERVER}" \
  --docker-username="${DOCKER_USER}" \
  --docker-password="${DOCKER_PASSWORD}" \
  --docker-email="${DOCKER_EMAIL}"

echo "Done!"
echo
echo "Listing all secrets in namespace '${NAMESPACE}'"
kubectl --namespace "${NAMESPACE}" get secrets
echo
echo "Bye!"
