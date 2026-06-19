{{- /* GitOps renderer for ArgoCD */ -}}

{{- /* To create a renderer for different GitOps tooling, create a new `tpl` file with a
       named template. This renderer will be used when the `GitOps-Chart/resource-type`
       field of a particular resource manifest matches the name of the named template.

       The context object passed into the renderer will contain the following attribs:
        * `name` - The name of the resource (the key under which it is defined)
        * `global` - A reference to the `global` configuration of this chart (see values.yaml)
        * `manifest` - The patched manifest of this resource as an object (not YMAL)
        * `Chart` - Metadata about the GitOps chart (reference to .Chart)
        * `Release` - Metadata about this release of the GitOps chart (reference to .Release)
*/ -}}

{{- define "argocd-application" -}}
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: {{ if .global.noPrefix }}{{ kebabcase .name }}{{ else }}{{ printf "%s-%s" (default .Release.Name .global.prefix) (kebabcase .name) }}{{ end }}
  namespace: {{ .global.gitopsNamespace | default .Release.Namespace }}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  destination:
    namespace: {{ .manifest.namespace | default .Release.Namespace }}
    server: https://kubernetes.default.svc
  project: default
  source:
    {{- with default .global.commonChrat .manifest.chart }}
    repoURL: {{ .repoURL }}
    {{- with .path }}
    path: {{ . }}
    {{- end }}
    {{- with .name }}
    chart: {{ . }}
    {{- end }}
    targetRevision: {{ .version }}
    {{- end }}
    helm:
      values: |
        {{- toYaml .manifest.values | nindent 8 }}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
{{- end -}}
