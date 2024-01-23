## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.84.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | 4.84.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_compute_address.static_ingress](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_address) | resource |
| [google-beta_google_container_cluster.k8s](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_container_cluster) | resource |
| [google_artifact_registry_repository.docker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository) | resource |
| [google_compute_firewall.console_ssh](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.ingress](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_network.k8s_network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.k8s_subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_container_node_pool.ingress_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_container_node_pool.site_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_dns_managed_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone) | resource |
| [google_dns_record_set.site](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |
| [google_dns_record_set.www_site](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |
| [google_project_iam_custom_role.k8s](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_project_iam_custom_role.kubeip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_project_iam_member.iam_member_kluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.iam_member_kubeip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.k8s](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.kubeip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.kubeip_workload_identity_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_client_config.provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment for the GKE cluster | `string` | `"prod"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to apply to resources | `string` | `"wisnewski"` | no |
| <a name="input_pods_cidr"></a> [pods\_cidr](#input\_pods\_cidr) | The secondary ip range to use for pods | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to host the cluster in | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to host the cluster in | `string` | `""` | no |
| <a name="input_services_cidr"></a> [services\_cidr](#input\_services\_cidr) | The secondary ip range to use for services | `string` | n/a | yes |
| <a name="input_subnetwork_cidr"></a> [subnetwork\_cidr](#input\_subnetwork\_cidr) | Cidr range for the subnetwork | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | The zone where the cluster is hosted | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The clustername name |
| <a name="output_ingress_pool"></a> [ingress\_pool](#output\_ingress\_pool) | The ingress pool name |
| <a name="output_k8s_config"></a> [k8s\_config](#output\_k8s\_config) | Configuration for k8s provider |
| <a name="output_kubeip_filter"></a> [kubeip\_filter](#output\_kubeip\_filter) | The filter for kubeip sepc to locat static ips |
| <a name="output_kubeip_service_account"></a> [kubeip\_service\_account](#output\_kubeip\_service\_account) | The service account to use for kubeip GKE workload identity binding |
| <a name="output_site_pool"></a> [site\_pool](#output\_site\_pool) | The site pool name |
