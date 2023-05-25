resource "azurerm_container_group" "aci" {
  name                        = var.container_group_name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  os_type                     = var.os_type
  ip_address_type             = var.ip_address_type
  dns_name_label              = var.dns_name_label
  dns_name_label_reuse_policy = var.dns_name_label_reuse_policy
  subnet_ids                  = var.ip_address_type == "Private" ? [data.azurerm_subnet.subnet.id] : null
  restart_policy              = var.restart_policy
  zones                       = var.zones

  identity {
    type = "SystemAssigned"
  }

  dynamic "init_container" {
    for_each = var.init_container == null ? {} : { "init_container" = var.init_container }

    content {
      name                         = init_container.value["name"]
      image                        = init_container.value["image"]
      environment_variables        = init_container.value["environment_variables"]
      secure_environment_variables = init_container.value["secure_environment_variables"]
      commands                     = init_container.value["commands"]
    }
  }

  dynamic "container" {
    for_each = { for k in nonsensitive(var.containers) : k.name => k }

    content {
      name                         = container.key
      image                        = container.value["image"]
      cpu                          = container.value["cpu"]
      memory                       = container.value["memory"]
      cpu_limit                    = container.value["cpu_limit"]
      memory_limit                 = container.value["memory_limit"]
      environment_variables        = container.value["environment_variables"]
      secure_environment_variables = container.value["secure_environment_variables"]
      commands                     = container.value["commands"]

      dynamic "ports" {
        for_each = { for k in container.value["ports"] : "${k.port}-${k.protocol}" => k if k != null }

        content {
          port     = ports.value["port"]
          protocol = ports.value["protocol"]
        }
      }

      dynamic "readiness_probe" {
        for_each = container.value["readiness_probe"] == null ? {} : { "readiness_probe" = container.value["readiness_probe"] }

        content {
          exec                  = readiness_probe.value["exec"]
          initial_delay_seconds = readiness_probe.value["initial_delay_seconds"]
          period_seconds        = readiness_probe.value["period_seconds"]
          failure_threshold     = readiness_probe.value["failure_threshold"]
          success_threshold     = readiness_probe.value["success_threshold"]
          timeout_seconds       = readiness_probe.value["timeout_seconds"]

          dynamic "http_get" {
            for_each = readiness_probe.value["http_get"] == null ? {} : { "http_get" = readiness_probe.value["http_get"] }

            content {
              path         = http_get.value["path"]
              port         = http_get.value["port"]
              scheme       = http_get.value["scheme"]
              http_headers = http_get.value["http_headers"]
            }
          }
        }
      }

      dynamic "liveness_probe" {
        for_each = container.value["liveness_probe"] == null ? {} : { "liveness_probe" = container.value["liveness_probe"] }

        content {
          exec                  = liveness_probe.value["exec"]
          initial_delay_seconds = liveness_probe.value["initial_delay_seconds"]
          period_seconds        = liveness_probe.value["period_seconds"]
          failure_threshold     = liveness_probe.value["failure_threshold"]
          success_threshold     = liveness_probe.value["success_threshold"]
          timeout_seconds       = liveness_probe.value["timeout_seconds"]

          dynamic "http_get" {
            for_each = liveness_probe.value["http_get"] == null ? {} : { "http_get" = liveness_probe.value["http_get"] }

            content {
              path         = http_get.value["path"]
              port         = http_get.value["port"]
              scheme       = http_get.value["scheme"]
              http_headers = http_get.value["http_headers"]
            }
          }
        }
      }
    }
  }

  diagnostics {

    log_analytics {
      workspace_id  = data.azurerm_log_analytics_workspace.logs.workspace_id
      workspace_key = data.azurerm_log_analytics_workspace.logs.primary_shared_key
    }
  }

  dynamic "exposed_port" {
    for_each = { for k in var.exposed_ports : "${k.port}-${k.protocol}" => k if k != null }

    content {
      port     = exposed_port.value["port"]
      protocol = exposed_port.value["protocol"]
    }
  }

  dynamic "image_registry_credential" {
    for_each = var.image_registry_credential == null ? {} : { "image_registry_credential" = var.image_registry_credential }

    content {
      user_assigned_identity_id = image_registry_credential.value["user_assigned_identity_id"]
      username                  = image_registry_credential.value["username"]
      password                  = image_registry_credential.value["password"]
      server                    = image_registry_credential.value["server"]
    }
  }

  tags = var.tags
}
