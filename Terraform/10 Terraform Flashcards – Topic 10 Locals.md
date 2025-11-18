Here are the **Notion-friendly Markdown flashcards** for **Terraform Locals** – great for interview prep and revision! 🧠

---

## 📚 Terraform Flashcards – Topic 10: Locals

````markdown
# 📘 Terraform Flashcards – Topic 10: Locals

---

## 💡 Flashcard 1: What are Terraform locals?
**Q:** What is a `local` in Terraform?
**A:** `locals` are named expressions used to simplify repeated values and expressions across your Terraform configuration.

---

## 💡 Flashcard 2: Are locals input variables?
**Q:** Are locals like variables that can be passed in during runtime?
**A:** ❌ No. Unlike variables, locals cannot accept input values and are computed only within the module they are defined.

---

## 💡 Flashcard 3: Basic syntax of local values?
**Q:** What is the syntax to define locals?
**A:**
```hcl
locals {
  region = "eastus"
}
````

Use it like: `location = local.region`

---

## 💡 Flashcard 4: What is a common use case for locals?

**Q:** Why use locals in Terraform?  
**A:** To avoid repeating expressions like `lookup`, `join`, or dynamic naming. Improves readability and reusability.

---

## 💡 Flashcard 5: Can locals depend on resources?

**Q:** Can you assign a resource output to a local?  
**A:** ❌ No. Locals must not depend on resource attributes; they are evaluated before resources are created.

---

## 💡 Flashcard 6: Real-world example – reusable tags

**Q:** Show a real-world example of reusable tags using locals.  
**A:**

```hcl
locals {
  tags = {
    Owner       = "DevOpsTeam"
    Environment = "dev"
  }
}

resource "azurerm_resource_group" "example" {
  name = "rg-demo"
  tags = local.tags
}
```

---

## 💡 Flashcard 7: Real-world example – dynamic naming

**Q:** How can you use locals for naming resources dynamically?  
**A:**

```hcl
locals {
  env  = "prod"
  name = "vm-${local.env}-001"
}
```

---

## 💡 Flashcard 8: Real-world example – conditional lookup

**Q:** How do you use a local with lookup values?  
**A:**

```hcl
variable "env" { default = "dev" }

locals {
  instance_type = {
    dev  = "Standard_B1s"
    prod = "Standard_D2s_v3"
  }

  selected_type = local.instance_type[var.env]
}
```

---

## 💡 Flashcard 9: Can you reassign locals?

**Q:** Can you override or reassign a local once it’s declared?  
**A:** ❌ No. Locals are immutable. You must define a new one if needed.

---

## 💡 Flashcard 10: Summary Table – Locals vs Variables

|Feature|`variable`|`local`|
|---|---|---|
|Accepts input|✅ Yes|❌ No|
|Used for computation|❌ No|✅ Yes|
|Immutable|✅ Yes|✅ Yes|
|Scope|Module-level|Module-level|

```

---

Would you like to proceed with **Topic 11: Terraform Functions** next?
```