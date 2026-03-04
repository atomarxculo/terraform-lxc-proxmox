<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 3.0.2-rc07 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 3.0.2-rc07 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_lxc.lxc](https://registry.terraform.io/providers/telmate/proxmox/3.0.2-rc07/docs/resources/lxc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_lxc_count"></a> [lxc\_count](#input\_lxc\_count) | n/a | `number` | n/a | yes |
| <a name="input_lxc_ips"></a> [lxc\_ips](#input\_lxc\_ips) | Lista de IPs separadas por comas (validada por Jenkins) | `string` | n/a | yes |
| <a name="input_lxc_names"></a> [lxc\_names](#input\_lxc\_names) | Lista de nombres separada por comas (generada por Jenkins) | `string` | n/a | yes |
| <a name="input_lxc_password"></a> [lxc\_password](#input\_lxc\_password) | n/a | `string` | n/a | yes |
| <a name="input_lxc_size"></a> [lxc\_size](#input\_lxc\_size) | n/a | `string` | `"small"` | no |
| <a name="input_lxc_storage"></a> [lxc\_storage](#input\_lxc\_storage) | n/a | `string` | `"local"` | no |
| <a name="input_lxc_tags"></a> [lxc\_tags](#input\_lxc\_tags) | Lista de tags separada por comas | `string` | `""` | no |
| <a name="input_lxc_template"></a> [lxc\_template](#input\_lxc\_template) | n/a | `string` | `"ubuntu-24.04-standard_24.04-2_amd64.tar.zst"` | no |
| <a name="input_proxmox_api_url"></a> [proxmox\_api\_url](#input\_proxmox\_api\_url) | n/a | `string` | n/a | yes |
| <a name="input_proxmox_node"></a> [proxmox\_node](#input\_proxmox\_node) | n/a | `string` | n/a | yes |
| <a name="input_proxmox_token_id"></a> [proxmox\_token\_id](#input\_proxmox\_token\_id) | n/a | `string` | n/a | yes |
| <a name="input_proxmox_token_secret"></a> [proxmox\_token\_secret](#input\_proxmox\_token\_secret) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->