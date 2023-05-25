variable "container_group_name" {
  type        = string
  description = "The name of the container group to deploy"
}

variable "location" {
  type        = string
  description = "The primary location of the container group"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to deploy the container group to"
}

variable "os_type" {
  type        = string
  default     = "Linux"
  description = "The OS of the container, Windows or Linux"
}

variable "ip_address_type" {
  type        = string
  default     = "Private"
  description = "Specifies the IP address type of the container. Public, Private or None"
}

variable "dns_name_label" {
  type        = string
  default     = null
  description = "The DNS label/name for the container group's IP. Not supported when deploying to virtual networks"
}

variable "dns_name_label_reuse_policy" {
  type        = string
  default     = "Noreuse"
  description = "Allow reuse of dns label at variou scopes"
}

variable "restart_policy" {
  type        = string
  default     = "Always"
  description = "Restart policy for the container group"
}

variable "zones" {
  type        = list(string)
  default     = null
  description = "Availability zones to deploy to"
}

variable "init_container" {
  type = object({
    name                         = string
    image                        = string
    environment_variables        = optional(map(string))
    secure_environment_variables = optional(map(string))
    commands                     = optional(list(string))
  })
  default     = null
  sensitive   = true
  description = "Init container definition"
}

variable "containers" {
  type = list(object(
    {
      name                         = string
      image                        = string
      cpu                          = string
      memory                       = string
      cpu_limit                    = optional(string)
      memory_limit                 = optional(string)
      environment_variables        = optional(map(string))
      secure_environment_variables = optional(map(string))
      commands                     = optional(list(string))
      ports = optional(list(object({
        port     = number
        protocol = optional(string, "TCP")
      })))
      readiness_probe = optional(object({
        exec                  = optional(list(string))
        initial_delay_seconds = optional(number)
        period_seconds        = optional(number, 10)
        failure_threshold     = optional(number, 3)
        success_threshold     = optional(number, 1)
        timeout_seconds       = optional(number, 10)
        http_get = optional(object({
          path         = string
          port         = number
          scheme       = optional(string, "Https")
          http_headers = optional(map(string))
        }))
      }))
      liveness_probe = optional(object({
        exec                  = optional(list(string))
        initial_delay_seconds = optional(number)
        period_seconds        = optional(number, 10)
        failure_threshold     = optional(number, 3)
        success_threshold     = optional(number, 1)
        timeout_seconds       = optional(number, 10)
        http_get = optional(object({
          path         = string
          port         = number
          scheme       = optional(string, "Https")
          http_headers = optional(map(string))
        }))
      }))
    }
  ))
  sensitive   = true
  description = "Container definitions"
}

variable "exposed_ports" {
  type = list(object({
    port     = number
    protocol = optional(string, "TCP")
  }))
  description = "Default ports to expose for all containers"
}

variable "image_registry_credential" {
  type = object({
    user_assigned_identity_id = optional(string)
    username                  = optional(string)
    password                  = optional(string)
    server                    = optional(string)
  })
  default     = null
  description = "Credentials for accessing container registry"
}

variable "subnet_name" {
  type        = string
  description = "The name of the resource group of the subnet to deploy private endpoint"
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the resource group of the subnet to deploy private endpoint"
}

variable "subnet_resource_group_name" {
  type        = string
  description = "The name of the resource group of the subnet to deploy private endpoint"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of Log Analytics Workspace to send diagnostics"
}

variable "log_analytics_workspace_resource_group_name" {
  type        = string
  description = "Resource Group of Log Analytics Workspace to send diagnostics"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
}
