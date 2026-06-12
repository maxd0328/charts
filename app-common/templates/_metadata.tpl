{{/*
  This file contains metadata definitions for the rest of the chart, including naming templates
  and common labels/selectors.
*/}}

{{/* ---------------------------------------------------------------------------------------------
  `metadata.name` - Name of the chart.
  We truncate at 63 chars because some k8s names are limited to this (by the DNS naming spec).
*/}}

{{- define "metadata.name" -}}
{{- default .Chart.Name .Values.global.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* ---------------------------------------------------------------------------------------------
  `metadata.releaseName` - Fully qualified app name used in resource naming.
  It is equal to the name of the Helm release, or `.Values.global.releaseNameOverride` if set.
*/}}

{{- define "metadata.releaseName" -}}
{{- default .Release.Name .Values.global.releaseNameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* ---------------------------------------------------------------------------------------------
  `metadata.chart` - String identifier containing the chart's name and version.
  Cannot be overridden and is guaranteed to be identical across releases.
*/}}

{{- define "metadata.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* ---------------------------------------------------------------------------------------------
  `metadata.labels` - Common labels applied to all resources in this chart
*/}}

{{- define "metadata.labels" -}}
helm.sh/chart: {{ include "metadata.chart" . }}
{{ include "metadata.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* ---------------------------------------------------------------------------------------------
  `metadata.selectorLabels` - Selector labels used for the pods in this chart's application
*/}}

{{- define "metadata.selectorLabels" -}}
app.kubernetes.io/name: {{ include "metadata.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* ---------------------------------------------------------------------------------------------
  `metadata.serviceAccountName` - Name of the service account to use
*/}}

{{- define "metadata.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "metadata.qualifiedName" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
