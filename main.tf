# Network Module
module "network" {
  source = "./modules/network"

  project_name = var.project_name
  environment  = var.environment
  location     = var.location
  vnet_cidr    = var.vnet_cidr
  tags         = var.tags
}

# AKS Cluster Module
module "aks_cluster" {
  source = "./modules/aks-cluster"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.network.resource_group_name
  vnet_subnet_id      = module.network.aks_subnet_id
  node_count          = var.aks_node_count
  node_size           = var.aks_node_size
  kubernetes_version  = var.kubernetes_version
  tags                = var.tags

  # Ensure network is created first
  depends_on = [module.network]
}
