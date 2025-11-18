Here’s your **Terraform Learning Plan: Topic 14 – Local Values**, fully elaborated with **5 real-world Azure cloud examples** and **Notion-friendly Markdown flashcards**.

---

# ✅ Topic 14: **Local Values in Terraform**

---

## 📘 What Are Local Values?

Local values are used to **assign names to expressions** or combinations of expressions to make Terraform configurations:

- More **readable**
    
- **Maintainable**
    
- Avoid **duplication**
    

They are defined using the `locals` block and **exist only within the current module**.

```hcl
locals {
  prefix = "${var.environment}-${var.project}"
}
```

---

## 🚀 Why Use Locals?

- Avoid repeating complex expressions.
    
- Centralize values that are reused often.
    
- Simplify module logic and naming conventions.
    
- Help compute derived values without exposing them.
    

---

## 📦 Syntax

```hcl
locals {
  name_suffix     = "${var.environment}-${var.location}"
  resource_prefix = "${local.name_suffix}-${var.project}"
}
```

---

## ☁️ 5 Real-World Azure Examples of `locals`

---

### ✅ Example 1: **Resource Naming Convention**

```hcl
locals {
  rg_name = "${var.environment}-${var.location}-rg"
}

resource "azurerm_resource_group" "main" {
  name     = local.rg_name
  location = var.location
}
```

🔹 **Use case:** Consistent resource group naming based on environment and location.

---

### ✅ Example 2: **Centralized Tag Definition**

```hcl
locals {
  common_tags = {
    Environment = var.environment
    Owner       = var.owner
    Project     = var.project
  }
}

resource "azurerm_storage_account" "sa" {
  name                     = "examplestorage"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.common_tags
}
```

🔹 **Use case:** Apply consistent tags to all Azure resources without repetition.

---

### ✅ Example 3: **VM Configuration Optimization**

```hcl
locals {
  vm_size = var.is_production ? "Standard_DS2_v2" : "Standard_B2ms"
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "webvm"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  size                = local.vm_size
  # ...
}
```

🔹 **Use case:** Automatically adjust VM size based on the environment (prod/dev).

---

### ✅ Example 4: **Simplified Naming Across Resources**

```hcl
locals {
  name_base = "${var.project}-${var.environment}"
}

resource "azurerm_storage_account" "sa" {
  name                     = "${local.name_base}sa"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

🔹 **Use case:** Standardized naming prefix reused across resources (storage, vms, etc.).

---

### ✅ Example 5: **Locals with Complex Logic**

```hcl
locals {
  location_short = lookup(
    {
      "eastus"      = "eus"
      "westus2"     = "wus2"
      "centralindia"= "cin"
    },
    var.location,
    "unknown"
  )

  short_name = "${var.project}-${local.location_short}"
}

output "resource_short_name" {
  value = local.short_name
}
```

🔹 **Use case:** Map verbose Azure region names to shorter codes for naming.

---

## 🧠 Key Notes

- `locals` block does **not create infrastructure**.
    
- All `local` values are **evaluated during the plan phase**.
    
- Use with conditional logic, mappings, dynamic blocks, and naming.
    

---

## 📚 Terraform Flashcards – Topic 14: Local Values (Markdown – Notion Friendly)

```markdown
# 📚 Terraform Flashcards – Topic 14: Local Values

## Flashcard 1
**Q:** What are local values in Terraform?  
**A:** Named expressions used within a module to simplify and reuse values.

## Flashcard 2
**Q:** Where can local values be used?  
**A:** Only within the module where they're declared.

## Flashcard 3
**Q:** What is a common use case for locals in Azure Terraform configurations?  
**A:** Defining consistent naming conventions and common tags.

## Flashcard 4
**Q:** Do locals affect resource creation directly?  
**A:** No, they just store computed values used by other resources.

## Flashcard 5
**Q:** Can locals depend on variables and other locals?  
**A:** Yes, locals can use variables and previously defined locals.

## Flashcard 6
**Q:** How do locals improve Terraform code quality?  
**A:** By reducing duplication, enhancing readability, and centralizing logic.

## Flashcard 7
**Q:** Example of a local used to define a resource name in Azure?  
**A:** `local.rg_name = "${var.environment}-${var.location}-rg"`

## Flashcard 8
**Q:** Can locals include conditional logic like ternary expressions?  
**A:** Yes, for example: `local.vm_size = var.prod ? "DS2" : "B2"`

## Flashcard 9
**Q:** What's the Terraform syntax to declare locals?  
**A:** `locals { key = value }`

## Flashcard 10
**Q:** How are locals evaluated during a plan?  
**A:** Terraform evaluates all locals when the plan is created.
```

---

Would you like this added to your flashcard ZIP or exported in PDF/Notion/HTML format?