variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "terraform-iac"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "vnet_cidr" {
  description = "CIDR block for VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aks_node_count" {
  description = "Number of AKS nodes"
  type        = number
  default     = 2
}

variable "aks_node_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "Cloud-Infrastructure-Automation"
    ManagedBy   = "Terraform"
    Owner       = "DevOps-Team"
  }
}
