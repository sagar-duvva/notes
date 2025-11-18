Here’s a detailed breakdown of **Terraform Core Best Practices**, each with **real-world Azure examples** and **flashcards in Notion-friendly Markdown format**.

---

# 🌍 Terraform Core Best Practices (with Azure Examples)

These practices ensure your Terraform codebase remains **maintainable, scalable, secure**, and **easy to collaborate on**.

---

## 1. 🔢 Version Pinning

### 📌 Why?

To ensure consistent behavior across environments and avoid unexpected breaking changes from provider or Terraform upgrades.

### ✅ Best Practice

- Use `required_version` in `terraform` block
    
- Pin provider versions in `required_providers`
    

```hcl
terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80.0"
    }
  }
}
```

### 💡 Azure Use Case Example

1. Ensure Terraform v1.6+ is used in a CI pipeline for Azure infra.
    
2. Avoid breaking changes in `azurerm` provider with a version lock.
    
3. Enforce version compatibility across dev/test/prod.
    
4. Validate upgrade paths in a staging environment.
    
5. Use automated upgrade checks via `terraform init -upgrade`.
    

---

## 2. 🔁 DRY Principle (Don’t Repeat Yourself)

### 📌 Why?

To reduce redundancy, improve reusability, and simplify updates across your infrastructure code.

### ✅ Best Practice

- Use modules
    
- Use `locals`, variables, and dynamic blocks
    

```hcl
module "network" {
  source              = "./modules/network"
  resource_group_name = var.rg_name
  location            = var.location
  vnet_name           = var.vnet_name
}
```

### 💡 Azure Use Case Example

1. Create reusable module for Azure VNets.
    
2. Share NSG module across environments.
    
3. Standardize storage account deployments using modules.
    
4. Use `locals` for consistent tags.
    
5. Use dynamic blocks to loop NSG rules.
    

---

## 3. 🏷️ Naming Conventions

### 📌 Why?

To maintain consistency, readability, and easier resource tracking and auditing in Azure Portal and logs.

### ✅ Best Practice

Use standardized naming patterns like:

```hcl
locals {
  prefix = "${var.env}-${var.project}"
}

resource "azurerm_resource_group" "main" {
  name     = "${local.prefix}-rg"
  location = var.location
}
```

### 💡 Azure Use Case Example

1. Name VMs as `prod-web-01`, `dev-db-01`.
    
2. Prefix Azure Function Apps with `app-<env>-<feature>`.
    
3. Append `-nsg` to NSGs, `-vnet` to VNets.
    
4. Use consistent resource group naming: `rg-<env>-<app>`.
    
5. Enforce naming via custom Sentinel or `terraform validate`.
    

---

## 4. 🔐 Secure Secrets Handling

### 📌 Why?

To avoid leaking sensitive data into Terraform state, logs, or source control.

### ✅ Best Practice

- Use `sensitive = true`
    
- Use environment variables or Azure Key Vault
    
- Don’t commit `.tfstate` to Git
    

```hcl
variable "admin_password" {
  type      = string
  sensitive = true
}

resource "azurerm_linux_virtual_machine" "vm" {
  admin_password = var.admin_password
}
```

### 💡 Azure Use Case Example

1. Pass VM admin passwords from Azure Key Vault.
    
2. Store DB credentials securely using `azurerm_key_vault_secret`.
    
3. Never log secrets in outputs.
    
4. Mark sensitive outputs and variables.
    
5. Use Vault-backed secrets for CI/CD pipelines.
    

---

## 5. 🗂️ Modularization & Folder Structure

### 📌 Why?

To make code reusable, easier to maintain, and scalable across teams or environments.

### ✅ Best Practice

- Split by layers (network, compute, storage)
    
- Separate `modules/`, `environments/`, and `main.tf`
    

```
terraform/
│
├── modules/
│   ├── network/
│   └── compute/
│
├── environments/
│   ├── dev/
│   └── prod/
│
└── main.tf
```

### 💡 Azure Use Case Example

1. Use modules for AKS, App Gateway, and Key Vault.
    
2. Organize code by environments (dev/test/prod).
    
3. Apply separate state for networking and workloads.
    
4. Maintain separate CI/CD pipelines per environment.
    
5. Reuse common module for tagging and naming resources.
    

---

# 📇 Flashcards – Terraform Best Practices

```markdown
# 📘 Terraform Flashcards – Best Practices

## Flashcard 1
**Q:** Why should you pin the Terraform and provider versions?
**A:** To avoid unexpected changes and ensure consistency across environments.

## Flashcard 2
**Q:** How do you pin the AzureRM provider to a safe version range?
**A:** Use `version = "~> 3.80.0"` under `required_providers`.

## Flashcard 3
**Q:** What does the DRY principle stand for and how is it applied in Terraform?
**A:** Don't Repeat Yourself; use modules, locals, and dynamic blocks to reuse code.

## Flashcard 4
**Q:** Provide an Azure-based use case of the DRY principle.
**A:** Reuse a VNet module across dev, test, and prod environments.

## Flashcard 5
**Q:** Why are naming conventions important in Terraform?
**A:** They ensure clarity, consistency, and traceability of Azure resources.

## Flashcard 6
**Q:** Give a naming convention example for an Azure resource.
**A:** `prod-web-nsg` for a production NSG used by a web app.

## Flashcard 7
**Q:** What is a best practice for handling secrets in Terraform?
**A:** Use `sensitive = true`, environment variables, or fetch secrets from Azure Key Vault.

## Flashcard 8
**Q:** What should you never commit to version control in a Terraform project?
**A:** `.tfstate`, `.tfvars` with secrets, or any sensitive outputs.

## Flashcard 9
**Q:** Why modularize Terraform code?
**A:** To promote reuse, simplify management, and support scalability.

## Flashcard 10
**Q:** What's a good folder structure for a Terraform Azure project?
**A:** Separate `modules/`, `environments/`, and root-level configuration files.
```

---

Would you like me to export this section as a Markdown file or add it to your existing flashcards ZIP file?