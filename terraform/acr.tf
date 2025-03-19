# ================================================================
# Azure Container Registry (ACR) - Registro de Imágenes de Contenedor
# ================================================================

resource "azurerm_container_registry" "acr" {
  # Nombre único del ACR (debe ser globalmente único en Azure)
  name                = var.acr_name

  # Grupo de recursos donde se almacenará el ACR
  resource_group_name = azurerm_resource_group.rg.name

  # Ubicación del ACR
  location            = azurerm_resource_group.rg.location

  # Tipo de SKU del ACR:
  # Basic: Ideal para pruebas y entornos pequeños
  sku                 = "Basic"

  # Habilita el acceso administrativo con usuario y contraseña
  admin_enabled       = true
}