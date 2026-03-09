# Cloud-Infrastructure-Automation

Complete infrastructure-as-code solution for automated Azure AKS cluster provisioning using Terraform with modular, reusable components.

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)

## 🎯 Project Overview

An enterprise-grade Infrastructure as Code (IaC) solution that automates the complete provisioning of Azure Kubernetes Service (AKS) infrastructure. This project demonstrates advanced Terraform patterns including modular architecture, state management, and production-ready configurations for rapid environment deployment.

### Key Features
- **Modular Architecture** - Reusable network and compute modules
- **Auto-Scaling** - Dynamic node scaling (1-5 nodes) based on workload
- **Security First** - Network security groups, RBAC, managed identity
- **Monitoring Ready** - Integrated Log Analytics workspace
- **Multi-Environment** - Same code deploys dev, staging, and prod
- **One-Command Deploy** - Complete infrastructure in 15 minutes
- **Cost Optimized** - Destroy when not needed, recreate instantly

## 🏗️ Architecture

```
Terraform Configuration
         ↓
    ┌────┴────┐
    ↓         ↓
Network    Compute
Module     Module
    ↓         ↓
┌─────┐  ┌─────┐
│VNet │  │ AKS │
│NSG  │  │Node │
│Sub  │  │Pool │
└─────┘  └─────┘
    ↓         ↓
    └────┬────┘
         ↓
   Azure Cloud
         ↓
Production-Ready
  K8s Cluster
```

### Infrastructure Components

**Network Layer:**
- Virtual Network (10.0.0.0/16)
- AKS Subnet (10.0.0.0/24)
- Network Security Groups (HTTP, HTTPS, K8s API)
- Service Network (10.1.0.0/16)

**Compute Layer:**
- AKS Cluster with system-assigned identity
- Auto-scaling node pool (1-5 nodes)
- Azure CNI networking
- Standard load balancer

**Monitoring & Security:**
- Log Analytics workspace (30-day retention)
- Azure RBAC integration
- Network policies enabled
- Role assignments for cluster networking

## 📂 Project Structure

```
Cloud-Infrastructure-Automation/
│
├── main.tf                      # Main configuration - orchestrates modules
├── variables.tf                 # Input variables (environment, region, size)
├── outputs.tf                   # Output values (cluster info, kubeconfig)
├── providers.tf                 # Azure provider configuration
├── .gitignore                   # Terraform state and sensitive files
│
└── modules/
    │
    ├── network/                 # Network infrastructure module
    │   ├── main.tf             # VNet, subnet, NSG resources
    │   ├── variables.tf        # Network module inputs
    │   └── outputs.tf          # Network resource IDs
    │
    └── aks-cluster/            # AKS cluster module
        ├── main.tf             # AKS, monitoring, RBAC resources
        ├── variables.tf        # Cluster module inputs
        └── outputs.tf          # Cluster endpoint, kubeconfig
```

## 🛠️ Technologies & Tools

| Technology | Purpose | Version |
|------------|---------|---------|
| **Terraform** | Infrastructure as Code | >= 1.0 |
| **Azure CLI** | Azure authentication | >= 2.0 |
| **AzureRM Provider** | Terraform Azure integration | ~> 3.0 |
| **Azure AKS** | Managed Kubernetes service | 1.34+ |
| **Azure VNet** | Virtual networking | - |
| **Log Analytics** | Monitoring and logging | - |

## 🚀 Quick Start

### Prerequisites

```bash
# Install Terraform
brew install terraform  # macOS
# or download from https://www.terraform.io/downloads

# Install Azure CLI
brew install azure-cli  # macOS
# or download from https://docs.microsoft.com/cli/azure/install-azure-cli

# Login to Azure
az login
az account show  # Verify subscription
```

### Deployment Steps

#### 1. Clone Repository
```bash
git clone https://github.com/YOUR_USERNAME/Cloud-Infrastructure-Automation.git
cd Cloud-Infrastructure-Automation
```

#### 2. Initialize Terraform
```bash
terraform init
```

**Expected output:**
```
Initializing modules...
Initializing the backend...
Initializing provider plugins...
Terraform has been successfully initialized!
```

#### 3. Review Configuration
```bash
# Preview what will be created
terraform plan

# Should show: Plan: 8 to add, 0 to change, 0 to destroy
```

#### 4. Deploy Infrastructure
```bash
terraform apply

# Type 'yes' when prompted
# Wait 10-15 minutes for cluster creation
```

#### 5. Get Cluster Credentials
```bash
# Option 1: Use terraform output command
terraform output -raw get_credentials_command | bash

# Option 2: Direct az command
az aks get-credentials \
  --resource-group terraform-iac-dev-rg \
  --name terraform-iac-dev-aks

# Verify connection
kubectl get nodes
```

**Expected output:**
```
NAME                                STATUS   ROLES    AGE   VERSION
aks-default-12345678-vmss000000    Ready    <none>   5m    v1.34.3
aks-default-12345678-vmss000001    Ready    <none>   5m    v1.34.3
```

#### 6. Deploy Applications
```bash
# Deploy your applications from Projects 1 & 2
kubectl apply -f your-app-manifests/

# Verify deployments
kubectl get pods
kubectl get services
```

#### 7. Destroy Infrastructure (When Done)
```bash
terraform destroy

# Type 'yes' when prompted
# Wait 5-10 minutes for complete cleanup
```

## ⚙️ Configuration

### Customizing Variables

Edit `variables.tf` or create `terraform.tfvars`:

```hcl
# terraform.tfvars
project_name       = "my-project"
environment        = "prod"
location           = "eastus"
vnet_cidr          = "10.0.0.0/16"
aks_node_count     = 3
aks_node_size      = "Standard_D4s_v3"
kubernetes_version = "1.34"
```

### Environment-Specific Deployments

```bash
# Development environment
terraform apply -var="environment=dev" -var="aks_node_count=2"

# Staging environment
terraform apply -var="environment=staging" -var="aks_node_count=3"

# Production environment
terraform apply -var="environment=prod" -var="aks_node_count=5"
```

## 📊 Module Details

### Network Module

**Purpose:** Creates foundational networking infrastructure

**Resources Created:**
- Resource Group
- Virtual Network
- Subnet for AKS
- Network Security Group
- NSG Association

**Configuration:**
- VNet CIDR: 10.0.0.0/16
- AKS Subnet: 10.0.0.0/24 (auto-calculated)
- Security Rules: HTTP (80), HTTPS (443), K8s API (6443)

**Outputs:**
- Resource group name and ID
- VNet name and ID
- Subnet ID for AKS integration

---

### AKS Cluster Module

**Purpose:** Provisions production-ready Kubernetes cluster

**Resources Created:**
- AKS Cluster
- Log Analytics Workspace
- Role Assignment (Network Contributor)

**Configuration:**
- Auto-scaling: 1-5 nodes
- Network plugin: Azure CNI
- Network policy: Azure
- Load balancer: Standard
- Identity: System-assigned managed identity
- RBAC: Azure AD integration enabled

**Outputs:**
- Cluster name and endpoint
- Kubeconfig (sensitive)
- Node resource group

---
