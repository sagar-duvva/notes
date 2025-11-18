Awesome, ByteBuddy is ready! Let's dive into **🔹 Topic 8: Terraform `output` blocks**.

---

## 🧠 Topic 8: `output` in Terraform

The `output` block in Terraform is used to **display information after a successful `terraform apply`**—like resource names, IPs, secret values (if not sensitive), or anything computed.

### 📘 Syntax

```hcl
output "name" {
  value       = <expression>
  description = "Optional explanation"
  sensitive   = true|false
}
```

---

## ✅ Common Use Cases

|Use Case|Description|
|---|---|
|Display public IP of a VM|Useful after deployment for remote access|
|Share output with another module|Used in `module` outputs|
|Debug a variable or expression|Quick insight during development|
|Return sensitive data securely|Prevent displaying on console with `sensitive = true`|

---

## 💡 3 Real-World Examples

### 🔹 Example 1: Output Public IP of an Azure VM

```hcl
output "vm_public_ip" {
  value       = azurerm_public_ip.example.ip_address
  description = "Public IP address of the virtual machine"
}
```

### 🔹 Example 2: Output Resource Group Name

```hcl
output "resource_group" {
  value = azurerm_resource_group.rg.name
}
```

### 🔹 Example 3: Output a Sensitive Secret from Key Vault

```hcl
output "kv_secret" {
  value     = data.azurerm_key_vault_secret.db_password.value
  sensitive = true
}
```

This avoids showing the secret in CLI output or logs.

---

## 🔐 Sensitive Output

Marking `sensitive = true` helps hide the value in:

- Terraform plan/apply output
    
- Logs
    
- Console output  
    But note: it **does not encrypt the value** in state files.
    

---

## 📦 Outputs from Modules

Modules can export outputs like so:

**`modules/storage/output.tf`**

```hcl
output "storage_account_name" {
  value = azurerm_storage_account.example.name
}
```

You can access it from the root module:

```hcl
output "storage_name" {
  value = module.storage.storage_account_name
}
```

---

### 🛠 Command to View Outputs

```bash
terraform output
terraform output <name>
```

---

Would you like me to now generate:

1. 📓 Flashcards in Markdown (Notion-ready)
    
2. Proceed to **Topic 9: Data Sources**
    

Let me know!