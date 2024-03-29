
{{- if .Values.reset.enabled -}}
---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: reset-webshell
  namespace: {{ .Values.namespace | default .Release.Namespace }}
spec:
  jobTemplate:
    metadata:
      name: reset-webshell
    spec:
      template:
        metadata:
          creationTimestamp: null
        spec:
          restartPolicy: OnFailure
          containers:
          - command:
            - kubectl
            - rollout
            - restart
            - deployment
            - {{ include "webshell.fullname" . }}
            image: docker.io/bitnami/kubectl
            name: reset-webshell
          serviceAccount: reset-cronjob
  schedule: "{{ .Values.reset.schedule }}"

---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: reset-cronjob


---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: reset-cronjob
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: reset-cronjob
subjects:
- kind: ServiceAccount
  name: reset-cronjob
  namespace: {{ .Release.Namespace }}

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: reset-cronjob
rules:
- apiGroups:
  - apps
  resources:
  - deployments
  verbs:
  - get
  - patch
  - update
{{- end -}}