Here’s your **✅ Topic 13: Loops in Terraform**, fully explained with **Azure real-world examples** and **Notion-ready Markdown flashcards**.

---

# ✅ Topic 13: Loops in Terraform

---

## 🧠 What Are Loops in Terraform?

Loops in Terraform help you **dynamically create multiple resources** using concise, DRY (Don’t Repeat Yourself) code.

There are **three primary looping constructs**:

|Loop Type|Description|
|---|---|
|`count`|Creates multiple instances of a resource based on a number|
|`for_each`|Iterates over maps/sets to create named instances|
|`for`|Used for expressions, transformations, and inside variables|

---

## 🆚 count vs for_each

|Feature|`count`|`for_each`|
|---|---|---|
|Input Type|Integer|Map or Set|
|Index Access|`count.index`|Key or item name (`each.key`, `each.value`)|
|Deletion Risk|Index-based deletion can break|Stable keys reduce resource churn|
|Best For|Identical resources|Differentiated resources|

---

## ☁️ 5 Real-World Azure Use Cases with Loops

---

### ✅ 1. Create 3 Azure Resource Groups Using `count`

```hcl
variable "rg_names" {
  default = ["dev", "stage", "prod"]
}

resource "azurerm_resource_group" "rg" {
  count    = length(var.rg_names)
  name     = "rg-${var.rg_names[count.index]}"
  location = "East US"
}
```

👀 Creates 3 distinct resource groups with minimal code.

---

### ✅ 2. Deploy Azure Storage Accounts Using `for_each`

```hcl
variable "storage_accounts" {
  default = {
    "dev"   = "eastus"
    "stage" = "westeurope"
    "prod"  = "centralindia"
  }
}

resource "azurerm_storage_account" "sa" {
  for_each                 = var.storage_accounts
  name                     = "stor${each.key}001"
  resource_group_name      = "rg-${each.key}"
  location                 = each.value
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

🎯 Use-case: Storage accounts in different regions with predictable naming.

---

### ✅ 3. Create a List of Azure Tags Using `for` Expression

```hcl
variable "environments" {
  default = ["dev", "qa", "prod"]
}

locals {
  tags = { for env in var.environments : env => "${env}-owner" }
}

# Output example
output "env_tags" {
  value = local.tags
}
```

📌 Outputs:

```hcl
{
  dev  = "dev-owner"
  qa   = "qa-owner"
  prod = "prod-owner"
}
```

---

### ✅ 4. Generate Multiple Subnets in a VNet using `for_each`

```hcl
variable "subnet_config" {
  default = {
    "subnet1" = "10.0.1.0/24"
    "subnet2" = "10.0.2.0/24"
    "subnet3" = "10.0.3.0/24"
  }
}

resource "azurerm_subnet" "subnets" {
  for_each             = var.subnet_config
  name                 = each.key
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value]
}
```

💡 Useful in VNet-based microservice segmentation.

---

### ✅ 5. Use `for` to Transform List of Tags into Map

```hcl
variable "tags_list" {
  default = [
    { key = "env", value = "dev" },
    { key = "owner", value = "teamA" }
  ]
}

locals {
  tags_map = {
    for tag in var.tags_list : tag.key => tag.value
  }
}
```

📦 Result:

```hcl
{
  "env"   = "dev"
  "owner" = "teamA"
}
```

---

## 🧠 Best Practices

- Use `count` for identical resources
    
- Use `for_each` when dealing with **named** or **map-based** resources
    
- Use `for` to **transform** or **build** dynamic values
    

---

## 📚 Terraform Flashcards – Topic 13: Loops (Markdown – Notion Friendly)

````markdown
# 📚 Terraform Flashcards – Topic 13: Loops

## Flashcard 1
**Q:** What are the three types of loops in Terraform?  
**A:** `count`, `for_each`, and `for` expressions.

## Flashcard 2
**Q:** What is the key difference between `count` and `for_each`?  
**A:** `count` uses numeric indexing; `for_each` uses named keys (maps or sets).

## Flashcard 3
**Q:** When should you prefer `for_each` over `count`?  
**A:** When creating differentiated or named resources (e.g., subnets, tags).

## Flashcard 4
**Q:** What Terraform loop would you use to dynamically transform a list into a map?  
**A:** Use `for` expression.

## Flashcard 5
**Q:** How do you access the current index in a `count` loop?  
**A:** Using `count.index`.

## Flashcard 6
**Q:** Give an Azure example where `count` is useful.  
**A:** Creating 3 identical Azure Resource Groups for `dev`, `stage`, and `prod`.

## Flashcard 7
**Q:** How can you loop over a map of storage account names and locations?  
**A:** Using `for_each` on the map variable.

## Flashcard 8
**Q:** How do you avoid resource address drift when using loops?  
**A:** Prefer `for_each` over `count` to preserve named keys.

## Flashcard 9
**Q:** Can `for_each` be used with a list?  
**A:** No, only with maps or sets (lists must be converted).

## Flashcard 10
**Q:** What does this do?  
```hcl
{ for item in list : item => upper(item) }
````

**A:** Transforms a list into a map where key = item, value = uppercased item.

```

---

### ✅ Want Me to:

- Add this to your ZIP flashcard bundle?
- Generate a visual diagram for loops in Terraform?
- Continue with **Topic 14: Modules**?

Let me know, ByteBuddy is ready!
```