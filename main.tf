terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }

 backend "azurerm" {
    resource_group_name  = "Terraform"
    storage_account_name = "terraform4storage"
    container_name       = "tfstatefile"
     key                 = "dev.Terraform.tfstatefile"
    
}
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  # subscription_id = var.subscription_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  # tenant_id       = var.tenant_id
}


# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "project-resource-group"
  location = "West Europe"
}

# Create a container registery
resource "azurerm_container_registry" "example" {
  name                = "ProjectContainerRegistry5590"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Premium"
}

# Create a kubernates cluster
resource "azurerm_kubernetes_cluster" "example" {
  name                = "project-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "projectaks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

