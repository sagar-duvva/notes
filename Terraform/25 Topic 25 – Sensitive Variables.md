Here’s the **Terraform Learning Plan: Topic 25 – Sensitive Variables**, fully explained with **5 real-world Azure cloud examples** and **Notion-friendly Markdown flashcards**.

---

# ✅ Topic 25: **Sensitive Variables in Terraform**

---

## 🔐 What Are Sensitive Variables?

Terraform’s `sensitive` flag is used to **mark values (usually inputs or outputs)** as **confidential**, which prevents them from being displayed in CLI output, logs, and state diffs.

It does **not encrypt** them, but **hides their values from accidental exposure**.

---

## 🔧 How to Declare a Sensitive Variable

```hcl
variable "client_secret" {
  description = "Azure AD Application secret"
  type        = string
  sensitive   = true
}
```

When you run `terraform plan` or `apply`, Terraform will hide this value:

```hcl
+ client_secret = (sensitive value)
```

---

## 🔍 Key Concepts

|Feature|Description|
|---|---|
|**Hides Output**|Prevents secret values from being shown in terminal|
|**Not Encrypted**|Still stored in plain text inside `terraform.tfstate`|
|**Use Caution**|Use secure backends and secret management tools|

---

## 📁 Sensitive Outputs

```hcl
output "admin_password" {
  value     = azurerm_windows_virtual_machine.vm.admin_password
  sensitive = true
}
```

---

## ☁️ 5 Real-World Azure Examples

---

### ✅ Example 1: **Azure AD App Client Secret**

```hcl
variable "client_secret" {
  description = "Azure App Registration Secret"
  type        = string
  sensitive   = true
}

resource "azurerm_key_vault_secret" "aad_secret" {
  name         = "aad-client-secret"
  value        = var.client_secret
  key_vault_id = azurerm_key_vault.example.id
}
```

🔹 **Use case:** Store and pass sensitive secrets to Azure Key Vault securely.

---

### ✅ Example 2: **VM Admin Password**

```hcl
variable "admin_password" {
  type      = string
  sensitive = true
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-vm"
  admin_username      = "adminuser"
  admin_password      = var.admin_password
  ...
}
```

🔹 **Use case:** Protect admin credentials when provisioning Azure virtual machines.

---

### ✅ Example 3: **Output Secret Key**

```hcl
output "vm_password" {
  value     = var.admin_password
  sensitive = true
}
```

🔹 **Use case:** Keep sensitive output from showing up in `terraform apply` and logs.

---

### ✅ Example 4: **App Configuration Connection String**

```hcl
variable "app_config_conn_string" {
  type      = string
  sensitive = true
}

resource "azurerm_app_configuration" "example" {
  name                = "example-appconfig"
  resource_group_name = var.rg_name
  location            = var.location
}

resource "azurerm_key_vault_secret" "app_config_secret" {
  name         = "app-config-connection"
  value        = var.app_config_conn_string
  key_vault_id = azurerm_key_vault.example.id
}
```

🔹 **Use case:** Safely store connection strings to App Config.

---

### ✅ Example 5: **SQL Database Passwords**

```hcl
variable "sql_password" {
  type      = string
  sensitive = true
}

resource "azurerm_mssql_server" "sqlserver" {
  name                         = "example-sql"
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.sql_password
}
```

🔹 **Use case:** Protect database admin credentials.

---

## 🛡 Best Practices

- Always mark secrets as `sensitive`.
    
- Use `terraform output -json` and parse carefully in CI/CD.
    
- Store secrets in Azure Key Vault or secure CI/CD environments.
    
- Encrypt state files (use secure remote backends like Azure Blob with encryption).
    

---

## 🧠 Bonus Tip

Even with `sensitive = true`, values are still stored **in clear text in `terraform.tfstate`** – secure your state files using:

- Azure Blob Storage backend with encryption
    
- Enable RBAC and firewall rules
    
- Use `terraform login` and Terraform Cloud for extra security
    

---

## 📚 Terraform Flashcards – Topic 25: Sensitive Variables (Markdown – Notion Friendly)

````markdown
# 📚 Terraform Flashcards – Topic 25: Sensitive Variables

## Flashcard 1
**Q:** What does the `sensitive = true` attribute do in Terraform?  
**A:** It hides sensitive variable or output values from CLI output and logs.

## Flashcard 2
**Q:** Does marking a variable as sensitive encrypt its value in state files?  
**A:** No, it only hides it from output; the value remains in plain text in state.

## Flashcard 3
**Q:** How do you define a sensitive input variable?  
**A:** 
```hcl
variable "admin_password" {
  type      = string
  sensitive = true
}
````

## Flashcard 4

**Q:** How do you prevent sensitive data from being printed in `terraform apply`?  
**A:** Use `sensitive = true` in output blocks or input variables.

## Flashcard 5

**Q:** What's a real-world Azure use case of sensitive variables?  
**A:** Passing VM admin passwords or Azure AD app secrets securely.

## Flashcard 6

**Q:** What are the risks even with sensitive variables?  
**A:** Data is still in plain text in the `.tfstate` file.

## Flashcard 7

**Q:** How can you protect sensitive Terraform state files?  
**A:** Use secure remote backends like Azure Blob with encryption and RBAC.

## Flashcard 8

**Q:** Can you use `sensitive` with outputs?  
**A:** Yes, `output "secret" { value = ... sensitive = true }`

## Flashcard 9

**Q:** How does Terraform display sensitive values in logs?  
**A:** `(sensitive value)` is shown instead of actual content.

## Flashcard 10

**Q:** What Terraform command can help fetch sensitive outputs securely?  
**A:** `terraform output -json | jq` for controlled access.

```

---

Would you like this topic added to your ZIP package of flashcards, or exported to PDF or Notion?
```