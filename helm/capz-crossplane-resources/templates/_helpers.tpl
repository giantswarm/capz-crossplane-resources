{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label. A label value is at
most 63 characters and begins and ends alphanumeric: the cut of a long version
(a branch build's <version>-dev.<branch>.<date>.<time>.<sha>, or the
<version>+<digest> helm-controller installs) can land on any run of ".", "_"
(from "+") and "-", so the whole run is trimmed.
*/}}
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimAll "-._" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "labels.common" -}}
app: {{ include "name" . | quote }}
{{ include "labels.selector" . }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
application.giantswarm.io/team: {{ index .Chart.Annotations "io.giantswarm.application.team" | quote }}
helm.sh/chart: {{ include "chart" . | quote }}
{{- end -}}

{{/*
Name of the management cluster.
*/}}
{{- define "managementCluster" -}}
{{- required "managementCluster is required" .Values.managementCluster -}}
{{- end -}}

{{/*
Azure subscription ID that holds the CAPZ identity: capzIdentity.subscriptionId,
else the subscription of the management cluster's own AzureCluster.
*/}}
{{- define "capzIdentity.subscriptionId" -}}
{{- with .Values.capzIdentity.subscriptionId -}}
{{- . -}}
{{- else -}}
{{- $mc := include "managementCluster" . -}}
{{- $azureCluster := lookup "infrastructure.cluster.x-k8s.io/v1beta1" "AzureCluster" "org-giantswarm" $mc -}}
{{- dig "spec" "subscriptionID" "" $azureCluster | required (printf "capzIdentity.subscriptionId is required: the AzureCluster org-giantswarm/%s doesn't exist or has no spec.subscriptionID" $mc) -}}
{{- end -}}
{{- end -}}

{{/*
ARM ID of the CAPZ identity, the external name of the observed
UserAssignedIdentity.
*/}}
{{- define "capzIdentity.resourceId" -}}
{{- $mc := include "managementCluster" . -}}
{{- printf "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.ManagedIdentity/userAssignedIdentities/%s"
  (include "capzIdentity.subscriptionId" .)
  (.Values.capzIdentity.resourceGroup | default $mc)
  (.Values.capzIdentity.name | default (printf "%s-capz" $mc)) -}}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "labels.selector" -}}
app.kubernetes.io/name: {{ include "name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end -}}
