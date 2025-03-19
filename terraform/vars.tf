
variable "azure_subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "azure_tenant_id" {
  description = "ID del tenant de Azure"
  type        = string
}

variable "resource_group_name" {
  default = "rg-devops-cp2"
}

variable "azure_region" {
  default = "Spain Central"
}

variable "project_name" {
  default = "devops-cp2"
}

variable "vm_size" {
  default = "Standard_B2s"
}

variable "vm_admin_username" {
  default = "azureuser"
}

variable "ssh_public_key_path" {
  default = "/home/escribano/.ssh/id_rsa.pub"
}

variable "acr_name" {
  default = "devopscp2acr"
}

variable "aks_name" {
  default = "devops-cp2-aks"
}

variable "aks_node_count" {
  default = 1
}

variable "aks_node_vm_size" {
  default = "Standard_B2s"
}
