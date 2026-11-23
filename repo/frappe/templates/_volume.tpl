{{/* Common ERPNext volumes definition */}}

{{- define "x.erpnext.volumes" -}}
volumes:
  - name: frappe-bench-drive
    persistentVolumeClaim:
      claimName: {{ .Release.Namespace }}-frappe-bench-pvc
  - name: backup-drive
    persistentVolumeClaim:
      claimName: {{ .Release.Namespace }}-backup-pvc
{{- end }}

{{- define "x.erpnext.volumeMounts" -}}
volumeMounts:
  - name: frappe-bench-drive
    mountPath: /home/frappe/frappe-bench/apps
    subPath: apps
  - name: frappe-bench-drive
    mountPath: /home/frappe/frappe-bench/config
    subPath: config
  - name: frappe-bench-drive
    mountPath: /home/frappe/frappe-bench/logs
    subPath: logs
  - name: frappe-bench-drive
    mountPath: /home/frappe/frappe-bench/sites
    subPath: sites
  - name: backup-drive
    mountPath: /logs
    subPath: logs
  - name: backup-drive
    mountPath: /backup
    subPath: backup
{{- end }}