#!/bin/bash
set -e
echo "User: $(whoami)"

echo
echo "You are about to create a docker hub registry secret for uoeld namespace"
echo "This registry authenticates the pull image from git, for private repos"
echo "It will be used to pull uoeld repository images"
echo "You can cancel before timeout..."
sleep 10

echo
echo "Creating the secret..."
DOCKER_REGISTRY_SERVER=docker.io
DOCKER_USER="ngatiafrankline"
DOCKER_EMAIL="fngatia@gmail.com"
DOCKER_PASSWORD="david3144%"

kubectl --namespace uoeld create secret docker-registry uoeld-docker-repo-key \
  --docker-server=$DOCKER_REGISTRY_SERVER \
  --docker-username=$DOCKER_USER \
  --docker-password=$DOCKER_PASSWORD \
  --docker-email=$DOCKER_EMAIL
echo "Done!"

echo
echo "Listing the all secret in namespace uoeld"
kubectl --namespace uoeld get secrets

echo
echo "Bye!"
