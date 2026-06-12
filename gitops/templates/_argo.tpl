{{- /* GitOps renderer for ArgoCD */ -}}

{{- /* To create a renderer for different GitOps tooling, create a new `tpl` file with a
       named template. This renderer will be used when the `gitopsTool` value matches
       the name of the named template.

       The context object passed into the renderer will contain the following attribs:
        * `name` - The name that should be used for the application GitOps resource(s)
        * `gitopsNamespace` - The namespace into which to deploy GitOps resource(s)
        * `namespace` - The release namespace for the app being deployed
        * `chart` - Details about the Helm chart which should be deployed for this app
          * This attribute contains `repoURL`, `version`, and one of `path` or `name`
        * `values` - Object (not YAML) containing the values to supply the Helm chart
*/ -}}

{{- define "argo" -}}
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: {{ .name }}
  namespace: {{ .gitopsNamespace }}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  destination:
    namespace: {{ .namespace }}
    server: https://kubernetes.default.svc
  project: default
  source:
    repoURL: {{ .chart.repoURL }}
    {{- with .chart.path }}
    path: {{ . }}
    {{- end }}
    {{- with .chart.name }}
    chart: {{ . }}
    {{- end }}
    targetRevision: {{ .chart.version }}
    helm:
      values: |
        {{- toYaml .values | nindent 8 }}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
{{- end -}}
