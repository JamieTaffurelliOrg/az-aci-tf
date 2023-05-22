# az-aci-tf
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.20 |
| <a name="provider_azurerm.logs"></a> [azurerm.logs](#provider\_azurerm.logs) | ~> 3.20 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_container_group.aci](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group) | resource |
| [azurerm_log_analytics_workspace.logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_group_name"></a> [container\_group\_name](#input\_container\_group\_name) | The name of the container group to deploy | `string` | n/a | yes |
| <a name="input_containers"></a> [containers](#input\_containers) | Container definitions | <pre>list(object({<br>    name                         = string<br>    image                        = string<br>    cpu                          = string<br>    memory                       = string<br>    cpu_limit                    = optional(string)<br>    memory_limit                 = optional(string)<br>    environment_variables        = optional(map(string))<br>    secure_environment_variables = optional(map(string))<br>    commands                     = optional(list(string))<br>    ports = optional(list(object({<br>      port     = number<br>      protocol = optional(string, "TCP")<br>    })))<br>    readiness_probe = object({<br>      exec                  = optional(string)<br>      initial_delay_seconds = optional(number)<br>      period_seconds        = optional(number, 10)<br>      failure_threshold     = optional(number, 3)<br>      success_threshold     = optional(number, 1)<br>      timeout_seconds       = optional(number, 10)<br>      http_get = optional(object({<br>        path         = string<br>        port         = number<br>        scheme       = optional(string, "Https")<br>        http_headers = optional(map(string))<br>      }))<br>    })<br>    liveness_probe = object({<br>      exec                  = optional(string)<br>      initial_delay_seconds = optional(number)<br>      period_seconds        = optional(number, 10)<br>      failure_threshold     = optional(number, 3)<br>      success_threshold     = optional(number, 1)<br>      timeout_seconds       = optional(number, 10)<br>      http_get = optional(object({<br>        path         = string<br>        port         = number<br>        scheme       = optional(string, "Https")<br>        http_headers = optional(map(string))<br>      }))<br>    })<br>  }))</pre> | n/a | yes |
| <a name="input_dns_name_label"></a> [dns\_name\_label](#input\_dns\_name\_label) | The DNS label/name for the container group's IP. Not supported when deploying to virtual networks | `string` | `null` | no |
| <a name="input_dns_name_label_reuse_policy"></a> [dns\_name\_label\_reuse\_policy](#input\_dns\_name\_label\_reuse\_policy) | Allow reuse of dns label at variou scopes | `string` | `"Noreuse"` | no |
| <a name="input_exposed_ports"></a> [exposed\_ports](#input\_exposed\_ports) | Default ports to expose for all containers | <pre>list(object({<br>    port     = number<br>    protocol = optional(string, "TCP")<br>  }))</pre> | n/a | yes |
| <a name="input_image_registry_credential"></a> [image\_registry\_credential](#input\_image\_registry\_credential) | Credentials for accessing container registry | <pre>object({<br>    user_assigned_identity_id = optional(string)<br>    username                  = optional(string)<br>    password                  = optional(string)<br>    server                    = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_init_container"></a> [init\_container](#input\_init\_container) | Init container definition | <pre>object({<br>    name                         = string<br>    image                        = string<br>    environment_variables        = optional(map(string))<br>    secure_environment_variables = optional(map(string))<br>    commands                     = optional(list(string))<br>  })</pre> | `null` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | Specifies the IP address type of the container. Public, Private or None | `string` | `"Private"` | no |
| <a name="input_location"></a> [location](#input\_location) | The primary location of the container group | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Name of Log Analytics Workspace to send diagnostics | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | Resource Group of Log Analytics Workspace to send diagnostics | `string` | n/a | yes |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | The OS of the container, Windows or Linux | `string` | `"Linux"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group to deploy the container group to | `string` | n/a | yes |
| <a name="input_restart_policy"></a> [restart\_policy](#input\_restart\_policy) | Restart policy for the container group | `string` | `"Always"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the resource group of the subnet to deploy private endpoint | `string` | n/a | yes |
| <a name="input_subnet_resource_group_name"></a> [subnet\_resource\_group\_name](#input\_subnet\_resource\_group\_name) | The name of the resource group of the subnet to deploy private endpoint | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply | `map(string)` | n/a | yes |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The name of the resource group of the subnet to deploy private endpoint | `string` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | Availability zones to deploy to | `list(string)` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->