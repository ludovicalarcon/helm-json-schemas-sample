{{- define "sample.image" -}}
{{- printf "%s:%s" .Values.image.repository .Values.image.tag }}
{{- end -}}

{{- define "sample.labels" -}}
app: {{ .Values.appName | quote }}
environment: {{ .Values.environment | quote }}
{{- end -}}
