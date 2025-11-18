
## ❓ Query 2: How Do `sensitive` Variables Work?

### 🔐 `sensitive = true` does:

- Hides value in `terraform plan`, `apply`, and state logs
    
- Still stored in state file, just hidden in CLI output
    
- Prevents accidental exposure of secrets
    

---

### ✅ Real-World Examples & Use Cases

#### 🔹 Example 1: Admin Password

```hcl
variable "admin_password" {
  type      = string
  sensitive = true
}
```

🧠 Use Case: Secure input for VM/DB admin password.

---

#### 🔹 Example 2: API Key

```hcl
variable "api_key" {
  type      = string
  sensitive = true
}
```

🧠 Use Case: Cloud provider API token or third-party keys.

---

#### 🔹 Example 3: Certificate PEM Data

```hcl
variable "cert_pem" {
  type      = string
  sensitive = true
}
```

🧠 Use Case: SSL/TLS certificate used by Application Gateway.

---

💡 Note: Even if it’s hidden in logs, **do not commit secrets to Git**—always use vault or secret backends.
