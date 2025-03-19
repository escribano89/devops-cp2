# ================================================================
# Creación del Grupo de Seguridad de Red (NSG)
# ================================================================

resource "azurerm_network_security_group" "vm_nsg" {
  # Nombre del Network Security Group (NSG)
  name                = "${var.project_name}-nsg"

  # Grupo de recursos donde se almacenará el NSG
  resource_group_name = azurerm_resource_group.rg.name

  # Ubicación de la red
  location            = azurerm_resource_group.rg.location
}

# ================================================================
# Reglas de Seguridad para la VM (NSG Rules)
# ================================================================

resource "azurerm_network_security_rule" "ssh_rule" {
  # Nombre de la regla de seguridad
  name                        = "AllowSSH"

  # Prioridad de la regla
  priority                    = 1001

  # Tráfico de entrada permitido
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"

  # Configuración de puertos
  source_port_range           = "*"
  destination_port_range      = "22"

  # Permite tráfico desde cualquier dirección IP
  source_address_prefix       = "*"
  destination_address_prefix  = "*"

  # Asigna la regla al NSG
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "http_rule" {
  name                        = "AllowHTTP"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "https_rule" {
  name                        = "AllowHTTPS"
  priority                    = 1003
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

# ================================================================
# Creación de la Interfaz de Red (NIC) para la VM
# ================================================================

resource "azurerm_network_interface" "vm_nic" {
  # Nombre de la NIC
  name                = "${var.project_name}-nic"

  # Grupo de recursos donde se almacenará la NIC
  resource_group_name = azurerm_resource_group.rg.name

  # Ubicación de la NIC
  location            = azurerm_resource_group.rg.location

  # Configuración de la IP
  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_ip.id
  }
}

# ================================================================
# Creación de la Clave SSH en Terraform
# ================================================================

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA" 
  rsa_bits  = 4096
}

# ================================================================
# Creación de la Máquina Virtual (VM) en Azure
# ================================================================

resource "azurerm_linux_virtual_machine" "vm" {
  # Nombre de la VM
  name                  = "${var.project_name}-vm"

  # Grupo de recursos donde se almacenará la VM
  resource_group_name   = azurerm_resource_group.rg.name

  # Ubicación de la VM 
  location              = azurerm_resource_group.rg.location

  # Tamaño de la máquina virtual
  size                  = var.vm_size

  # Nombre de usuario del administrador de la VM
  admin_username        = var.vm_admin_username

  # Asocia la NIC a la VM
  network_interface_ids = [azurerm_network_interface.vm_nic.id]

  # Deshabilita la autenticación con contraseña
  disable_password_authentication = true

  # Configuración de la clave SSH
  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  # Configuración del disco de la VM
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Selección de la imagen del sistema operativo
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "19_10-daily-gen2"
    version   = "19.10.202007100"
  }
}

# ================================================================
# Creación de la IP Pública para la Máquina Virtual
# ================================================================

resource "azurerm_public_ip" "vm_ip" {
  name                = "${var.project_name}-public-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  
  allocation_method   = "Static"
}

# ================================================================
# Asociación del NSG con la Interfaz de Red
# ================================================================

resource "azurerm_network_interface_security_group_association" "vm_nsg_association" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}