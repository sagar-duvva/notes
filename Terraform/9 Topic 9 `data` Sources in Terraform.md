Great! Let’s dive into **🔹 Topic 9: Terraform `data` sources** — one of the most powerful features in Terraform that enables **reading existing infrastructure** instead of creating it.

---

## 🧠 Topic 9: `data` Sources in Terraform

The `data` block allows Terraform to **fetch and use data from existing cloud resources**, such as already deployed VMs, Key Vault secrets, storage accounts, or even external APIs.

This is helpful when:

- You want to reference infrastructure not managed by Terraform
    
- You want to fetch dynamic information during apply
    
- You need to reuse values without hardcoding
    

---

## 📘 Basic Syntax

```hcl
data "<PROVIDER>_<RESOURCE_TYPE>" "<NAME>" {
  # configuration arguments
}
```

Then reference the values using:

```hcl
data.<PROVIDER>_<RESOURCE_TYPE>.<NAME>.<attribute>
```

---

## ✅ Common Use Cases

|Use Case|Description|
|---|---|
|Read from Azure Key Vault|Fetch secrets, connection strings, credentials|
|Get existing Resource Group|Prevent duplication of existing RGs|
|Reference an existing Storage Account|Use properties like endpoint, keys, etc.|
|Look up AMIs in AWS|Common for AWS EC2 provisioning|
|Use dynamic values in interpolations|Useful for templates, inputs, or conditional logic|

---

## 💡 3 Real-World Azure Examples

### 🔹 Example 1: Get an Existing Azure Resource Group

```hcl
data "azurerm_resource_group" "existing" {
  name = "my-production-rg"
}

output "rg_location" {
  value = data.azurerm_resource_group.existing.location
}
```

---

### 🔹 Example 2: Read a Secret from Azure Key Vault

```hcl
data "azurerm_key_vault" "example" {
  name                = "mykv"
  resource_group_name = "my-rg"
}

data "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  key_vault_id = data.azurerm_key_vault.example.id
}

output "password" {
  value     = data.azurerm_key_vault_secret.db_password.value
  sensitive = true
}
```

---

### 🔹 Example 3: Get a Storage Account

```hcl
data "azurerm_storage_account" "existing" {
  name                = "mystorageprod"
  resource_group_name = "prod-rg"
}

output "storage_endpoint" {
  value = data.azurerm_storage_account.existing.primary_blob_endpoint
}
```

---

## 🔁 When to Use `data` vs `resource`

|Feature|`resource`|`data`|
|---|---|---|
|Purpose|Creates infrastructure|Reads existing infrastructure|
|Example|Create VM, RG, KV|Read secret, existing RG, existing VM|
|Result|Adds resource to state file|Only reads from state or provider API|
|Updates|Managed by Terraform|Not managed, just read and referenced|

---

## 🛠 Useful Tips

- Use `terraform console` to explore `data` output values
    
- Avoid hardcoding existing resource attributes — fetch them dynamically
    
- Combine with `locals` and `outputs` for better reuse
    

---

Would you like me to generate the **flashcards in Markdown format** now before we move to **Topic 10: Terraform Locals**?