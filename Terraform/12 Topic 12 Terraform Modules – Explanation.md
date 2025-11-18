Awesome! Let’s dive into **Topic 12: Terraform Modules** — one of the most powerful and reusable features of Terraform.

---

## ✅ **Topic 12: Terraform Modules – Explanation**

### 🔹 What are Modules?

A **module** in Terraform is a container for multiple resources that are used together. Think of it like a reusable “function” in code — it lets you organize and reuse infrastructure across projects and environments.

There are 3 types of modules:

|Module Type|Description|
|---|---|
|Root Module|The main directory where Terraform is initialized and applied.|
|Child Module|A module called from another module (usually a folder or Git repo).|
|Public Module|Modules published in the [Terraform Registry](https://registry.terraform.io/).|

---

### 🔹 Why Use Modules?

- **Reusability**: Write once, use everywhere.
    
- **Consistency**: Apply the same standards across environments.
    
- **Maintainability**: Easier to update infra in a single place.
    
- **Scalability**: Break complex infra into manageable parts.
    

---

### 🔹 Basic Structure of a Module

```hcl
# modules/networking/main.tf
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.env}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}
```

### 🔹 Using a Module

```hcl
module "networking" {
  source              = "../modules/networking"
  location            = "eastus"
  resource_group_name = "rg-prod"
  env                 = "prod"
}
```

---

## 🔁 Module Inputs and Outputs

### Inputs (variables.tf)

```hcl
variable "location" {}
variable "env" {}
```

### Outputs (outputs.tf)

```hcl
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
```

---

## 💡 Best Practices for Modules

- Keep each module focused on one resource or logical group.
    
- Use `terraform-docs` to generate documentation.
    
- Use version control (Git) for tracking module changes.
    
- Always define `variables.tf`, `outputs.tf`, and `main.tf` in modules.
    

---

## 📦 Public vs Private Modules

|Type|Source Example|
|---|---|
|Local|`"../modules/networking"`|
|Git|`"git::https://github.com/user/repo.git//modules/networking"`|
|Terraform Registry|`"terraform-azure-modules/vnet/azurerm"`|

---

## 📌 Common Real-World Example Module Names

- `networking`
    
- `compute`
    
- `load_balancer`
    
- `app_gateway`
    
- `monitoring`
    
- `security`
    
- `database`
    

---

## 🧠 Flashcards: Terraform Modules (Markdown, Notion-Ready)

````markdown
# Terraform Modules Flashcards

## Q1: What is a Terraform module?
A reusable block of Terraform configuration that can include resources, input/output variables, etc.

## Q2: What are the types of modules in Terraform?
- Root Module
- Child Module
- Public Module (from Registry)

## Q3: Why use Terraform modules?
To ensure consistency, reusability, scalability, and maintainability in infrastructure deployments.

## Q4: How do you call a module?
```hcl
module "example" {
  source = "../modules/example"
  var1   = "value"
}
````

## Q5: What files should every module have?

- `main.tf`
    
- `variables.tf`
    
- `outputs.tf`
    
- Optionally `README.md`
    

## Q6: How do modules handle inputs and outputs?

Inputs are defined using `variable`, and outputs with `output` blocks, which are returned to the calling module.

## Q7: Can modules be nested?

Yes, modules can call other modules.

## Q8: What’s the difference between a local and remote module?

Local modules are in your repo (`../modules/xyz`). Remote modules come from Git or Terraform Registry.

## Q9: How can modules help in multi-environment setup?

You can call the same module in multiple environments like `prod`, `staging`, passing different variables.

## Q10: How do you pass variables to a module?

Using key-value pairs inside the module block in your root module.

```

---

Would you like a downloadable version of these flashcards or should we move on to **Topic 13: Backends**?
```