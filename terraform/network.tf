# ================================================================
# Creación de la Red Virtual (VNet)
# ================================================================

resource "azurerm_virtual_network" "vnet" {
  # Nombre de la red virtual
  name                = "${var.project_name}-vnet"

  # Grupo de recursos donde se almacenará la red virtual
  resource_group_name = azurerm_resource_group.rg.name

  # Ubicación donde se desplegará la red virtual
  location            = azurerm_resource_group.rg.location

  # Espacio de direcciones disponible para la red virtual
  address_space       = ["10.0.0.0/16"]
}

# ================================================================
# Creación de la Subred dentro de la VNet
# ================================================================

resource "azurerm_subnet" "subnet" {
  # Nombre de la subred
  name                 = "${var.project_name}-subnet"

  # Grupo de recursos donde se almacenará la subred
  resource_group_name  = azurerm_resource_group.rg.name

  # Red virtual a la que pertenece esta subred
  virtual_network_name = azurerm_virtual_network.vnet.name

  # Espacio de direcciones de la subred dentro de la VNet
  address_prefixes     = ["10.0.1.0/24"]
}