{{- /* GitOps renderer for FluxCD */ -}}

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

{{- define "flux" -}}

{{- end -}}
