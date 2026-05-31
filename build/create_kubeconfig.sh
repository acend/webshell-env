#!/bin/bash

TOKEN=$(cat /run/secrets/kubernetes.io/serviceaccount/token)
SA_NAMESPACE=$(cat /run/secrets/kubernetes.io/serviceaccount/namespace)
CA=$(cat /run/secrets/kubernetes.io/serviceaccount/ca.crt | base64 -w0)

KUBECONFIG_PATH="${KUBECONFIG_PATH:-${KUBECONFIG:-kubeconfig.yaml}}"
KUBECONFIG_NAMESPACE="${KUBECONFIG_NAMESPACE:-$SA_NAMESPACE}"
KUBECONFIG_CLUSTER_NAME="${KUBECONFIG_CLUSTER_NAME:-acend-training-cluster}"
KUBECONFIG_CONTEXT="${KUBECONFIG_CONTEXT:-acend-training}"
KUBECONFIG_USERNAME="${KUBECONFIG_USERNAME:-acend-user}"

mkdir -p "$(dirname "$KUBECONFIG_PATH")"

cat << EOF > "$KUBECONFIG_PATH"
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${CA}
    server: https://${CLUSTER_K8S_API_HOST}:6443
  name: ${KUBECONFIG_CLUSTER_NAME}
contexts:
- context:
    cluster: ${KUBECONFIG_CLUSTER_NAME}
    namespace: ${KUBECONFIG_NAMESPACE}
    user: ${KUBECONFIG_USERNAME}
  name: ${KUBECONFIG_CONTEXT}
current-context: ${KUBECONFIG_CONTEXT}
kind: Config
preferences: {}
users:
- name: ${KUBECONFIG_USERNAME}
  user:
    token: ${TOKEN}
EOF