# Kubernetes Remote Cluster Access Setup (kubectl + Helm)

## 1. Install kubectl (Local Machine)

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

kubectl version --client


## 2. Install Helm (Local Machine)

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm version


## 3. Prepare Kubernetes Admin Config (Remote Server)

mkdir k8s-admin-config && \
sudo cp /etc/kubernetes/admin.conf ~/k8s-admin-config/ && \
sudo chown -R ubuntu:ubuntu k8s-admin-config && \
cd k8s-admin-config && \
ls && \
pwd


## 4. Verify Cluster VIP Resolution (Remote Server)
This is the IP/Host of the Kubernetes cluster control plane

getent hosts uoeerpcontrollbvip

Example output:
41.89.169.218 uoeerpcontrollbvip uoeerpcontrollbvip.uoeld.ac.ke

getent hosts uoekenetwebprimary1
Example output:
197.136.17.30 uoekenetwebprimary1 uoekenetwebprimary1.uoeld.ac.ke


## 5. Copy kubeconfig to Local Machine
mkdir -p ~/.kube
scp -P 9220 ubuntu@41.89.169.220:/home/ubuntu/k8s-admin-config/admin.conf ~/.kube/uoeerp-config


## 6. Configure Local Host Resolution

Edit /etc/hosts:

sudo nano /etc/hosts
197.136.17.30 uoekenetwebprimary1 uoekenetwebprimary1.uoeld.ac.ke

Flush DNS cache:

sudo resolvectl flush-caches


## 7. Set kubeconfig (Local Machine)

export KUBECONFIG=~/.kube/uoeld-config


## 8. Verify Connection

kubectl cluster-info
kubectl get nodes
kubectl get pods -A


## 9. Install Tools Summary

kubectl - Kubernetes CLI
helm - Kubernetes package manager