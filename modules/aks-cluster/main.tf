# AKS Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.project_name}-${var.environment}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.project_name}-${var.environment}"
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = var.node_size
    vnet_subnet_id      = var.vnet_subnet_id
    
    # Enable auto-scaling (optional but recommended)
    enable_auto_scaling = true
    min_count          = 1
    max_count          = 5
    
    # Node labels
    node_labels = {
      environment = var.environment
      nodepool    = "default"
    }
    
    tags = var.tags
  }

  # Identity for AKS
  identity {
    type = "SystemAssigned"
  }

  # Network profile
  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    service_cidr      = "10.1.0.0/16"
    dns_service_ip    = "10.1.0.10"
  }

  # RBAC Configuration
  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
  }

  # Add-ons
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }

  tags = var.tags
}

# Log Analytics Workspace for monitoring
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.project_name}-${var.environment}-logs"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# Role assignment for AKS to manage resources
resource "azurerm_role_assignment" "aks_network" {
  scope                = var.vnet_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
}
