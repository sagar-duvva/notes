Here’s the **Notion-style Markdown version** of the **Terraform Topic 4: Configuration Files Flashcards**. You can copy this into Notion or any Markdown-compatible tool for easy review.

---

# 📘 Terraform Flashcards – Topic 4: Configuration Files (`.tf`)

---

Files written in HCL that define providers, resources, variables, outputs, and modules. File extension is `.tf`. They form the basis of any Terraform project.

---

Defines the primary infrastructure resources, providers, and settings for your Terraform deployment.

---

Declares input variables used in other files like `main.tf`. Helps parameterize configurations.

---

Specifies the outputs you want Terraform to return after apply. Useful for referencing in other modules or outputs.

---

Holds actual values for declared variables, allowing easy reuse of configs across environments.

---

Optional file to separate provider configurations (e.g., azurerm, aws) from the rest of the main file.

---

```hcl
variable "location" {
  type    = string
  default = "East US"
}
```

---

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "demo-rg"
  location = var.location
}
```

---

```hcl
output "rg_name" {
  value = azurerm_resource_group.rg.name
}
```

---

- Use modular files (`main.tf`, `variables.tf`, etc.)
    
- Keep secrets out of `.tf` files
    
- Use `terraform fmt` to maintain format
    
- Leverage `terraform.tfvars` for environment-specific configs
    

---

Would you like me to bundle this flashcard set into a downloadable `.md` or `.pdf` file now? Or should we continue with **Topic 5: Providers in Terraform**?