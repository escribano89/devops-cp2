# ================================================================
# Configuración del Proveedor de Terraform para Azure
# ================================================================

provider "azurerm" {
  features {}

  # ID de la suscripción de Azure donde se desplegarán los recursos
  subscription_id = var.azure_subscription_id

  # ID del Tenant de Azure
  tenant_id       = var.azure_tenant_id
}

# ================================================================
# Creación del Grupo de Recursos en Azure
# ================================================================

resource "azurerm_resource_group" "rg" {
  # Nombre del grupo de recursos
  # Todos los recursos de la infraestructura estarán dentro de este grupo
  name     = var.resource_group_name

  # Ubicación (región de Azure) donde se creará el grupo de recursos
  location = var.azure_region
}