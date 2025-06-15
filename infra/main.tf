terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.99"
    }
  }
}

provider "azurerm" {
  features {}
}

# ─────────────── Resource Group ───────────────
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# ─────────────── Azure Container Registry (ACR) ───────────────
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = false
}

# ─────────────── Container Apps Environment ───────────────
resource "azurerm_container_app_environment" "env" {
  name                = var.env_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
}

# ─────────────── User-Assigned Identity ───────────────
resource "azurerm_user_assigned_identity" "aca_uai" {
  name                = "${var.env_name}-uai"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

# ─────────────── Role Assignment: UAI can pull from ACR ───────────────
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.aca_uai.principal_id
}

# ─────────────── FRONTEND Container App ───────────────
resource "azurerm_container_app" "frontend" {
  name                         = var.frontend_name
  resource_group_name          = azurerm_resource_group.main.name
  container_app_environment_id = azurerm_container_app_environment.env.id
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aca_uai.id]
  }

  ingress {
    external_enabled = true
    target_port      = 3000

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = "frontend"
      image  = "${azurerm_container_registry.acr.login_server}/frontend:latest"
      cpu    = 0.5
      memory = "1Gi"
    }
  }

  registry {
    server   = azurerm_container_registry.acr.login_server
    identity = azurerm_user_assigned_identity.aca_uai.id
  }

  depends_on = [azurerm_role_assignment.acr_pull]
}

# ─────────────── BACKEND Container App ───────────────
resource "azurerm_container_app" "backend" {
  name                         = var.backend_name
  resource_group_name          = azurerm_resource_group.main.name
  container_app_environment_id = azurerm_container_app_environment.env.id
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aca_uai.id]
  }

  ingress {
    external_enabled = false
    target_port      = 8080

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = "users-api"
      image  = "${azurerm_container_registry.acr.login_server}/users-api:latest"
      cpu    = 0.5
      memory = "1Gi"
    }
  }

  registry {
    server   = azurerm_container_registry.acr.login_server
    identity = azurerm_user_assigned_identity.aca_uai.id
  }

  depends_on = [azurerm_role_assignment.acr_pull]
}
