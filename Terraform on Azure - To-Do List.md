# Terraform on Azure - To-Do List (Beginner → Advanced)

## 1. Environment Setup
- [ ] Install Terraform
- [ ] Install Azure CLI
- [ ] Install code editor (VS Code or equivalent)
- [ ] Log in to Azure CLI
- [ ] Set default Azure subscription

## 2. Terraform Basics
- [ ] Learn Terraform core concepts
  - Providers
  - Resources
  - Variables
  - Outputs
  - State
- [ ] Create first Terraform configuration
- [ ] Initialize Terraform project (`terraform init`)
- [ ] Run plan and apply (`terraform plan`, `terraform apply`)
- [ ] Destroy resources (`terraform destroy`)

## 3. Azure Provider and Resource Management
- [ ] Configure Azure provider
- [ ] Create Azure Resource Group
- [ ] Deploy basic Azure resources (storage, resource groups)
- [ ] Update and modify resources

## 4. Variables and Outputs
- [ ] Define variables (`variables.tf`)
- [ ] Use variables in resources
- [ ] Define outputs (`outputs.tf`)
- [ ] Reference outputs across modules

## 5. Networking in Azure
- [ ] Deploy Virtual Network (VNet)
- [ ] Deploy Subnets
- [ ] Deploy Network Security Groups (NSG)
- [ ] Configure route tables and network interfaces

## 6. Terraform State Management
- [ ] Understand local Terraform state
- [ ] Manage Terraform state with commands
- [ ] Configure remote state with Azure Storage
- [ ] Use state locking and workspaces

## 7. Advanced Resource Deployment
- [ ] Deploy Azure Virtual Machines (VM)
  - Network interface
  - Public IP
  - OS configuration
- [ ] Deploy Azure Storage Account
  - Containers
  - Access policies
- [ ] Deploy Azure App Services
- [ ] Deploy Azure SQL Database
- [ ] Apply resource tags and naming conventions

## 8. Modules and Reusability
- [ ] Create Terraform modules
- [ ] Use module inputs and outputs
- [ ] Reuse modules across projects
- [ ] Version control modules

## 9. Terraform Provisioners and Lifecycle
- [ ] Use provisioners (remote-exec, local-exec)
- [ ] Configure resource lifecycle (create_before_destroy, prevent_destroy)
- [ ] Handle dependencies between resources

## 10. Security and Best Practices
- [ ] Manage sensitive data with variables
- [ ] Use Azure Key Vault integration
- [ ] Follow naming conventions
- [ ] Organize Terraform code (folders, files, modules)
- [ ] Implement code linting and formatting (`terraform fmt`, `terraform validate`)

## 11. Testing and Automation
- [ ] Test Terraform configurations
- [ ] Use Terraform plan in CI/CD pipelines
- [ ] Automate deployments with GitHub Actions / Azure DevOps

## 12. Cleanup and Maintenance
- [ ] Destroy all resources safely
- [ ] Manage drift in Terraform state
- [ ] Update and upgrade Terraform versions
