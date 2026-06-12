{{/*
  This file contains some utility definitions used by this chart's templates.
*/}}

{{/* ---------------------------------------------------------------------------------------------
  Default affinities applied to all deployments. This configuration is merged with the affinities
  provided in the `values.yaml`, with the values file taking precedence.
*/}}

{{- define "utilities.defaultAffinity" -}}
podAntiAffinity:
  preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 1
      podAffinityTerm:
        labelSelector:
          matchLabels:
            {{- include "metadata.selectorLabels" . | nindent 12 }}
        topologyKey: kubernetes.io/hostname
{{- end -}}
