#!/bin/bash

TOKEN=$(cat /run/secrets/kubernetes.io/serviceaccount/token)
SA_NAMESPACE=$(cat /run/secrets/kubernetes.io/serviceaccount/namespace)
CA=$(cat /run/secrets/kubernetes.io/serviceaccount/ca.crt | base64 -w0)

KUBECONFIG_PATH="${KUBECONFIG_PATH:-${KUBECONFIG:-kubeconfig.yaml}}"
KUBECONFIG_NAMESPACE="${KUBECONFIG_NAMESPACE:-$SA_NAMESPACE}"
KUBECONFIG_CLUSTER_NAME="${KUBECONFIG_CLUSTER_NAME:-acend-training-cluster}"
KUBECONFIG_CONTEXT="${KUBECONFIG_CONTEXT:-acend-training}"
KUBECONFIG_USERNAME="${KUBECONFIG_USERNAME:-acend-user}"
KUBECONFIG_SERVER="${KUBECONFIG_SERVER:-https://${CLUSTER_K8S_API_HOST}:6443}"

mkdir -p "$(dirname "$KUBECONFIG_PATH")"

cat << EOF > "$KUBECONFIG_PATH"
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${CA}
    server: ${KUBECONFIG_SERVER}
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
$(if [ "${KUBECONFIG_USE_TOKENFILE:-false}" = "true" ]; then
    echo "    tokenFile: /run/secrets/kubernetes.io/serviceaccount/token"
  else
    echo "    token: ${TOKEN}"
  fi)
EOF