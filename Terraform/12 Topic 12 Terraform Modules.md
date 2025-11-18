Great! Let's move ahead with **🟩 Topic 12: Terraform Modules** — one of the most powerful and reusable features in Terraform.

---

## ✅ **Topic 12: Terraform Modules**

### 📘 What is a Module?

A **Terraform module** is simply a collection of `.tf` files in a folder. You can think of a module as a reusable unit of Terraform configuration.

You can:

- Use **local modules** (in the same repo).
    
- Use **remote modules** (GitHub, Terraform Registry, etc.).
    
- Break down complex projects into **manageable, logical units**.
    

---

### 🧩 **Why Use Modules?**

|Benefit|Description|
|---|---|
|Reusability|Define it once, use it multiple times (like a function).|
|Maintainability|Isolate infrastructure components.|
|Abstraction|Hide complex logic behind simple interfaces using variables and outputs.|
|Collaboration|Teams can independently develop and test modules.|
|Standardization|Enforce consistent practices across environments.|

---

### 📁 Basic Module Structure

```
/project-root
│
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
│
└── /modules
    └── /vm
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

### 🔍 Key Components of a Module

- `main.tf`: Resource definitions
    
- `variables.tf`: Input variables
    
- `outputs.tf`: Outputs exported to parent
    

---

### 🧪 Example 1: Simple Local Module

**File: main.tf (root)**

```hcl
module "vm_example" {
  source      = "./modules/vm"
  vm_name     = "myvm"
  environment = "dev"
}
```

**File: modules/vm/main.tf**

```hcl
resource "azurerm_virtual_machine" "this" {
  name     = var.vm_name
  location = "East US"
  # ...
}
```

**File: modules/vm/variables.tf**

```hcl
variable "vm_name" {}
variable "environment" {}
```

**File: modules/vm/outputs.tf**

```hcl
output "vm_name" {
  value = var.vm_name
}
```

---

### 🌍 Example 2: Using Remote Module from GitHub

```hcl
module "network" {
  source  = "git::https://github.com/terraform-azure-modules/vnet.git"
  name    = "prod-network"
  address_space = ["10.0.0.0/16"]
}
```

---

### ☁️ Example 3: Terraform Registry Module

```hcl
module "storage" {
  source  = "terraform-azure-modules/storage-account/azurerm"
  version = "2.5.0"

  name                     = "storacc123"
  resource_group_name      = "my-rg"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

---

### 🧠 Best Practices

|Practice|Tip|
|---|---|
|Keep modules small|1 resource type or logical unit per module|
|Use input/output variables|Don’t hardcode — expose them|
|Version your modules|For stability across environments|
|Validate with `terraform validate`|Ensure syntax and logic are sound|
|Document your modules|Add `README.md` in each module folder|

---

Would you like a downloadable **ZIP with full example folder structure**, or shall I generate **Notion-friendly Markdown flashcards** next before moving to Topic 13?