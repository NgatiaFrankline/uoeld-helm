{{/* image pull secrets */}}

{{ define "x.image.pull.secrets.manifest" -}}
{{- if .Values.addImagePullSecretsManifest }}
imagePullSecrets:
  - name: {{ .Release.Namespace }}-docker-repo-key
{{- end }}
{{- end }}
