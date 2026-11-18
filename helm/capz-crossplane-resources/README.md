# capz-crossplane-resources

Crossplane resources for CAPZ management clusters, such as an observe-only view of the management cluster's CAPZ identity.

**Homepage:** <https://github.com/giantswarm/capz-crossplane-resources>

## Source Code

* <https://github.com/giantswarm/capz-crossplane-resources>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | bool | `true` | Render the chart's resources. They need Crossplane's Azure provider, which only CAPZ management clusters run. |
| managementCluster | string | `""` | Name of the management cluster. The CAPZ identity's resource group and name and the Crossplane Azure ProviderConfig default to it. Required when `enabled` is `true`. |
| providerConfigName | string | `""` | Name of the Crossplane Azure ProviderConfig the resources use. Defaults to `managementCluster`. |
| capzIdentity.subscriptionId | string | `""` | Azure subscription ID that holds the CAPZ identity. Defaults to `spec.subscriptionID` of the AzureCluster `org-giantswarm/<managementCluster>`. |
| capzIdentity.resourceGroup | string | `""` | Resource group that holds the CAPZ identity. Defaults to `managementCluster`. |
| capzIdentity.name | string | `""` | Azure name of the CAPZ identity. Defaults to `<managementCluster>-capz`. |

## CI values

`ci/ci-values.yaml` holds the values the CI render (`helm template` in app-build-suite) needs beyond the defaults, such as a `required` value without a default.
