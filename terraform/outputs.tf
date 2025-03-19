# ================================================================
# Outputs - Variables de salida de Terraform
# ================================================================

# Devuelve la URL del Azure Container Registry (ACR)
# Este valor es útil para hacer login en el ACR con herramientas como Podman
output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

# Devuelve la dirección IP pública de la máquina virtual
# Esto permite conectarse por SSH o acceder a servicios en la VM
output "vm_public_ip" {
  value = azurerm_public_ip.vm_ip.ip_address
}

# Devuelve el nombre del clúster de Kubernetes (AKS)
# Se usa para interactuar con el clúster a través de Ansible
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}