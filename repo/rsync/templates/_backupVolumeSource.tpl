{{/* Choose backup volume type */}}

{{- define "x.backup.volume.source" }}

{{- if eq .Values.storage.type "pvc" }}
persistentVolumeClaim:
  claimName: {{ .Values.storage.pvcName }}
{{- else if eq .Values.storage.type "hostPath" }}
hostPath:
  path: {{ .Values.storage.hostPathUri }}
  type: Directory
{{- else }}
emptyDir: {}
{{- end }}

{{- end }}