# ================================================================
# Azure Kubernetes Service (AKS) - Creación del clúster de Kubernetes
# ================================================================

resource "azurerm_kubernetes_cluster" "aks" {
  # Nombre del clúster de Kubernetes en Azure
  name                = var.aks_name
  
  # Ubicación donde se desplegará el clúster
  location            = azurerm_resource_group.rg.location
  
  # Grupo de recursos donde se almacenará el clúster AKS
  resource_group_name = azurerm_resource_group.rg.name
  
  # Prefijo DNS para el acceso al clúster
  dns_prefix          = var.aks_name

  # Definición de los grupos de nodos de trabajo
  default_node_pool {
    # Nombre del pool de nodos
    name       = "default"
    
    # Número de nodos en el pool
    node_count = var.aks_node_count
    
    # Tamaño de las máquinas virtuales para los nodos del clúster
    vm_size    = var.aks_node_vm_size
  }

  # Configuración de la identidad gestionada por el sistema
  identity {
    type = "SystemAssigned"
  }
}

# ================================================================
# Asignación de rol para que AKS pueda extraer imágenes del ACR
# ================================================================

resource "azurerm_role_assignment" "aks_acr_pull" {
  # Definimos el "scope" de la asignación, que en este caso es el ACR
  scope = azurerm_container_registry.acr.id

  # Asignamos el rol "AcrPull" a la identidad de AKS
  # Esto permite que los nodos del clúster extraigan imágenes de contenedores desde el ACR
  role_definition_name = "AcrPull"

  # Se asocia el rol a la identidad de los nodos
  principal_id = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}