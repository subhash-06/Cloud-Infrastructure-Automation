# Network Outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.network.resource_group_name
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.network.vnet_name
}

output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = module.network.aks_subnet_id
}

# AKS Outputs
output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks_cluster.cluster_name
}

output "aks_cluster_endpoint" {
  description = "Endpoint for the AKS cluster"
  value       = module.aks_cluster.cluster_endpoint
}

output "aks_node_resource_group" {
  description = "Auto-generated resource group for AKS nodes"
  value       = module.aks_cluster.node_resource_group
}

# Kubeconfig (sensitive)
output "kube_config" {
  description = "Kubernetes config for cluster access"
  value       = module.aks_cluster.kube_config
  sensitive   = true
}

# Connection command
output "get_credentials_command" {
  description = "Command to get AKS credentials"
  value       = "az aks get-credentials --resource-group ${module.network.resource_group_name} --name ${module.aks_cluster.cluster_name}"
}
