Great! Let's dive into **🔟 Topic 10: Terraform Locals** — an essential concept for improving code **readability, reusability, and maintainability**.

---

## 🧠 What Are Terraform Locals?

**`locals`** in Terraform allow you to **define reusable expressions or computed values** that you can reference multiple times in your configuration.

They:

- Do **not** accept input like variables do
    
- Are evaluated at plan time
    
- Cannot be changed at runtime
    

---

## ✅ Basic Syntax

```hcl
locals {
  environment     = "production"
  region          = "eastus"
  instance_prefix = "web-${local.environment}"
}
```

Use with:

```hcl
name = "${local.instance_prefix}-01"
```

---

## 💡 Use Cases for Locals

|Use Case|Description|
|---|---|
|Reusing calculated values|Avoid repeating logic like `join`, `lookup`, etc.|
|Building dynamic names/tags|Prefixes/suffixes using locals|
|Cleaning up long or nested expressions|Store expression results to make config readable|
|Environment-based logic|E.g., different values for dev/prod|
|Centralizing common parameters|Like owner tags, region, environment, etc.|

---

## 🔁 3 Real-World Examples

---

### ✅ Example 1: Tag Reusability

```hcl
locals {
  common_tags = {
    Owner       = "DevOpsTeam"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_resource_group" "example" {
  name     = "rg-demo"
  location = "eastus"
  tags     = local.common_tags
}
```

> 🎯 **Why**: Centralize and reuse tags in multiple resources.

---

### ✅ Example 2: Dynamic Resource Naming

```hcl
locals {
  environment   = "prod"
  region        = "eastus"
  instance_name = "vm-${local.environment}-${local.region}"
}

output "instance_name" {
  value = local.instance_name
}
```

> 🎯 **Why**: Dynamically build a resource name based on environment/region.

---

### ✅ Example 3: Lookup-Based Configuration

```hcl
variable "env" {
  default = "prod"
}

locals {
  instance_type = {
    dev  = "Standard_B1s"
    prod = "Standard_D2s_v3"
  }

  selected_type = local.instance_type[var.env]
}

output "vm_size" {
  value = local.selected_type
}
```

> 🎯 **Why**: Use a lookup map inside locals to drive conditional values.

---

## 🛑 Things to Remember

- Locals **cannot depend on resources**
    
- You **cannot reassign** a local once declared
    
- Locals are **only for computation**, not for input
    

---

Would you like to proceed with the **Flashcards in Markdown format** for this topic next?