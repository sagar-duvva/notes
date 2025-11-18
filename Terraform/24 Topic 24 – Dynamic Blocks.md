Here’s **Terraform Learning Plan: Topic 24 – Dynamic Blocks**, fully elaborated with **5 real-world Azure cloud examples** and **Notion-friendly Markdown flashcards**.

---

# ✅ Topic 24: **Dynamic Blocks in Terraform**

---

## 📘 What are Dynamic Blocks?

Terraform's `dynamic` block is a special construct used **within a resource block** to **generate nested blocks dynamically**, based on complex input data like maps or lists.

It is most useful when you want to **create zero or more nested blocks** based on **variable input**, and you don't want to manually repeat code.

---

## 🔍 Syntax Overview

```hcl
dynamic "block_label" {
  for_each = <expression>
  content {
    # nested block body using `block_label.value`
  }
}
```

---

## ✅ Why Use Dynamic Blocks?

- Create nested blocks dynamically based on a list or map.
    
- Reduce code duplication.
    
- Enable **data-driven** resource generation.
    
- Support advanced **templating patterns**.
    

---

## ⚠️ Common Use Cases

- `dynamic "setting"` for `azurerm_app_service`
    
- `dynamic "ip_rule"` for `azurerm_storage_account_network_rules`
    
- `dynamic "tag"` or `dynamic "role_assignment"`
    

---

## ☁️ 5 Real-World Azure Examples

---

### ✅ Example 1: **Dynamic Inbound NSG Rules**

```hcl
variable "inbound_rules" {
  type = list(object({
    name                   = string
    priority               = number
    direction              = string
    access                 = string
    protocol               = string
    source_port_range      = string
    destination_port_range = string
    source_address_prefix  = string
    destination_address_prefix = string
  }))
}

resource "azurerm_network_security_group" "nsg" {
  name                = "web-nsg"
  location            = var.location
  resource_group_name = var.rg_name

  dynamic "security_rule" {
    for_each = var.inbound_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}
```

🔹 **Use case:** Automatically generate multiple NSG rules for Azure networking.

---

### ✅ Example 2: **App Service Application Settings**

```hcl
variable "app_settings" {
  type = map(string)
}

resource "azurerm_app_service" "app" {
  name                = "appservice001"
  location            = var.location
  resource_group_name = var.rg_name
  app_service_plan_id = azurerm_app_service_plan.plan.id

  site_config {}

  dynamic "app_settings" {
    for_each = var.app_settings
    content {
      name  = app_settings.key
      value = app_settings.value
    }
  }
}
```

🔹 **Use case:** Dynamically assign application settings using a map.

---

### ✅ Example 3: **Storage Account IP Rules**

```hcl
variable "allowed_ips" {
  type = list(string)
}

resource "azurerm_storage_account" "storage" {
  name                     = "examplestorage"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action = "Deny"

    dynamic "ip_rules" {
      for_each = var.allowed_ips
      content {
        ip_address = ip_rules.value
      }
    }
  }
}
```

🔹 **Use case:** Restrict storage access based on a dynamic list of IPs.

---

### ✅ Example 4: **Role Assignments to Azure Resources**

```hcl
variable "role_assignments" {
  type = list(object({
    role_definition_name = string
    principal_id         = string
  }))
}

resource "azurerm_role_assignment" "assignments" {
  for_each             = { for idx, val in var.role_assignments : idx => val }
  scope                = azurerm_resource_group.rg.id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}
```

🔹 **Use case:** Dynamically assign RBAC roles to different users or services.

---

### ✅ Example 5: **Dynamic Tags on Resources**

```hcl
variable "tags" {
  type = map(string)
}

resource "azurerm_resource_group" "rg" {
  name     = "example-rg"
  location = "East US"

  tags = var.tags
}
```

🔹 **Use case:** Pass tags dynamically from input variable using a map.

---

## 💡 Best Practices

- Keep logic minimal inside `dynamic` blocks.
    
- Use `for_each`, not `count`.
    
- Avoid nesting dynamic inside dynamic unless absolutely necessary.
    
- Can be used **only for nested blocks** – not the top-level resource block.
    

---

## 📚 Terraform Flashcards – Topic 24: Dynamic Blocks (Markdown – Notion Friendly)

```markdown
# 📚 Terraform Flashcards – Topic 24: Dynamic Blocks

## Flashcard 1
**Q:** What is a dynamic block in Terraform?  
**A:** A construct used to dynamically generate nested blocks based on complex input data.

## Flashcard 2
**Q:** What is the syntax of a dynamic block?  
**A:** `dynamic "block_label" { for_each = [...] content { ... } }`

## Flashcard 3
**Q:** When should dynamic blocks be used?  
**A:** When you need to generate zero or more nested blocks from a list or map.

## Flashcard 4
**Q:** Can you use dynamic blocks at the top level of a Terraform resource?  
**A:** No, only within nested blocks.

## Flashcard 5
**Q:** What data types are commonly used with `for_each` in dynamic blocks?  
**A:** Lists and maps.

## Flashcard 6
**Q:** Give an Azure use case for dynamic blocks.  
**A:** Creating multiple NSG security rules dynamically.

## Flashcard 7
**Q:** How do you access each item inside a dynamic block?  
**A:** Using `block_label.value`.

## Flashcard 8
**Q:** Can dynamic blocks be nested?  
**A:** Yes, but it's not recommended unless necessary.

## Flashcard 9
**Q:** Example of generating dynamic IP rules for Azure Storage?  
**A:** `dynamic "ip_rules" { for_each = var.allowed_ips ... }`

## Flashcard 10
**Q:** Are dynamic blocks evaluated during the plan phase?  
**A:** Yes, just like other expressions.
```

---

Would you like me to add this topic to the ZIP file of Markdown flashcards or export it to PDF/Notion?