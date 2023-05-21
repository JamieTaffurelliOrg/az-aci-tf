resource "azurerm_container_group" "aci" {
  name                        = var.container_group_name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  os_type                     = var.os_type
  ip_address_type             = var.ip_address_type
  dns_name_label              = var.dns_name_label
  dns_name_label_reuse_policy = var.dns_name_label_reuse_policy
  subnet_ids                  = [data.azurerm_subnet.subnet.id]
  restart_policy              = var.restart_policy
  zones                       = var.zones

  identity {
    type = "SystemAssigned"
  }

  dynamic "init_container" {
    for_each = var.init_container == null ? {} : { "init_container" = var.init_container }

    content {
      name                         = init_container.name
      image                        = init_container.image
      environment_variables        = init_container.environment_variables
      secure_environment_variables = init_container.secure_environment_variables
      commands                     = init_container.commands
    }
  }

  dynamic "container" {
    for_each = { for k in var.containers : k.name => k }

    content {
      name                         = container.name
      image                        = container.image
      cpu                          = container.cpu
      memory                       = container.memory
      cpu_limit                    = container.cpu_limit
      memory_limit                 = container.memory_limit
      environment_variables        = container.environment_variables
      secure_environment_variables = container.secure_environment_variables
      commands                     = container.commands

      dynamic "ports" {
        for_each = { for k in container.value["ports"] : "${k.port}-${k.protocol}" => k if k != null }

        content {
          port     = ports.port
          protocol = ports.protocol
        }
      }

      dynamic "readiness_probe" {
        for_each = { "readiness_probe" = container.value["readiness_probe"] }

        content {
          exec                  = readiness_probe.exec
          initial_delay_seconds = readiness_probe.initial_delay_seconds
          period_seconds        = readiness_probe.period_seconds
          failure_threshold     = readiness_probe.failure_threshold
          success_threshold     = readiness_probe.success_threshold
          timeout_seconds       = readiness_probe.timeout_seconds

          dynamic "http_get" {
            for_each = readiness_probe.value["http_get"] == null ? {} : { "http_get" = readiness_probe.value["http_get"] }

            content {
              path         = http_get.path
              port         = http_get.port
              scheme       = http_get.scheme
              http_headers = http_get.http_headers
            }
          }
        }
      }

      dynamic "liveness_probe" {
        for_each = { "liveness_probe" = container.value["liveness_probe"] }

        content {
          exec                  = liveness_probe.exec
          initial_delay_seconds = liveness_probe.initial_delay_seconds
          period_seconds        = liveness_probe.period_seconds
          failure_threshold     = liveness_probe.failure_threshold
          success_threshold     = liveness_probe.success_threshold
          timeout_seconds       = liveness_probe.timeout_seconds

          dynamic "http_get" {
            for_each = liveness_probe.value["http_get"] == null ? {} : { "http_get" = liveness_probe.value["http_get"] }

            content {
              path         = http_get.path
              port         = http_get.port
              scheme       = http_get.scheme
              http_headers = http_get.http_headers
            }
          }
        }
      }
    }
  }

  diagnostics {

    log_analytics {
      workspace_id  = data.azurerm_log_analytics_workspace.logs.id
      workspace_key = data.azurerm_log_analytics_workspace.logs.primary_shared_key
    }
  }

  dynamic "exposed_port" {
    for_each = { for k in var.exposed_ports : "${k.port}-${k.protocol}" => k if k != null }

    content {
      port     = exposed_port.port
      protocol = exposed_port.protocol
    }
  }

  dynamic "image_registry_credential" {
    for_each = var.image_registry_credential == null ? {} : { "image_registry_credential" = var.image_registry_credential }

    content {
      user_assigned_identity_id = image_registry_credential.user_assigned_identity_id
      username                  = image_registry_credential.username
      password                  = image_registry_credential.password
      server                    = image_registry_credential.server
    }
  }

  tags = var.tags
}
