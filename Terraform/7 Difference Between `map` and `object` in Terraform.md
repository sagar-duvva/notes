Great questions, ByteBuddy is ready to clarify them all step-by-step:

---

## ❓ Query 1: Difference Between `map` and `object` in Terraform

### 🔸 Similarity

Both `map` and `object` store key-value pairs.

### 🔸 Key Differences

|Feature|`map`|`object`|
|---|---|---|
|Structure|Homogeneous key-value pairs|Structured and typed key-value pairs|
|Type Strictness|Loosely typed|Strictly typed (you define key types and values)|
|Use Case|General configurations or dynamic dictionaries|Strongly typed data models like Azure SKU or metadata|

---

### ✅ Real-World Examples & Use Cases

#### 🔹 Example 1: Tags (use `map`)

```hcl
variable "tags" {
  type = map(string)
}

resource "azurerm_resource_group" "main" {
  name     = "rg1"
  location = "eastus"
  tags     = var.tags
}
```

🧠 Use Case: Flexible user-defined metadata.

---

#### 🔹 Example 2: Virtual Machine Configuration (use `object`)

```hcl
variable "vm_config" {
  type = object({
    name     = string
    size     = string
    location = string
  })
}
```

🧠 Use Case: Structurally defined input for critical infrastructure.

---

#### 🔹 Example 3: Database Settings (object vs map)

```hcl
# object: enforces key structure
variable "db_settings" {
  type = object({
    username = string
    password = string
  })
}

# map: allows arbitrary keys
variable "db_options" {
  type = map(string)
}
```

🧠 Use Case: Use `object` when keys must exist; use `map` when keys may vary.
