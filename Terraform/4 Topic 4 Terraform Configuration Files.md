Awesome! Let’s dive into **🔹 Topic 4: Terraform Configuration Files (`*.tf`)** — the heart of how Terraform works.

---

## 🔧 What Are Terraform Configuration Files?

Terraform configuration files define:

- **Resources** (what you want to create)
    
- **Providers** (like Azure, AWS)
    
- **Variables**, **Outputs**, **Modules**, and more
    

These files use **HCL (HashiCorp Configuration Language)**, and typically end with `.tf`.

---

## 📁 Common Terraform Files in a Project

|File Name|Purpose|
|---|---|
|`main.tf`|Main configuration (resources, providers, etc.)|
|`variables.tf`|Input variables and types|
|`outputs.tf`|Output values exported after `apply`|
|`terraform.tfvars`|Variable values (secrets, environment-specific values)|
|`provider.tf`|(optional) Declares cloud providers|
|`backend.tf`|(optional) Remote state backend configuration|

---

## 📘 Syntax Breakdown

### ✅ Resource Block

```hcl
resource "azurerm_resource_group" "example" {
  name     = "my-rg"
  location = var.location
}
```

### ✅ Variable Declaration

```hcl
variable "location" {
  type    = string
  default = "East US"
}
```

### ✅ Output Block

```hcl
output "resource_group_name" {
  value = azurerm_resource_group.example.name
}
```

### ✅ Provider Configuration

```hcl
provider "azurerm" {
  features {}
}
```

---

## 🌍 3 Real-World Examples

---

### 🧪 Example 1: Deploy a Resource Group using input variables

📄 `main.tf`

```hcl
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}
```

📄 `variables.tf`

```hcl
variable "rg_name" {
  type = string
}

variable "location" {
  type    = string
  default = "East US"
}
```

📄 `terraform.tfvars`

```hcl
rg_name = "prod-rg"
```

---

### 🧪 Example 2: Add a Virtual Network to the same config

```hcl
resource "azurerm_virtual_network" "vnet" {
  name                = "prod-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
```

---

### 🧪 Example 3: Output VNet name and location

📄 `outputs.tf`

```hcl
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet_location" {
  value = azurerm_virtual_network.vnet.location
}
```

---

## 🧠 Best Practices

- Keep configurations modular (`main.tf`, `variables.tf`, etc.)
    
- Use `terraform.tfvars` to manage environment-specific inputs
    
- Always format using `terraform fmt`
    
- Store secrets in secure locations, not directly in `.tf` files
    

---

Would you like me to prepare and share downloadable **Flashcards for Topic 4: Terraform Configuration Files** now?