Perfect! Let's dive into **🧩 Topic 7: Terraform Variables** — one of the most important features for **parameterizing and reusing configurations** across environments.

---

## 🧩 Topic 7: Terraform Variables

---

### 🔹 What are Variables in Terraform?

Variables in Terraform allow **dynamic input values** for your configuration.  
They promote **reuse**, **flexibility**, and **environment customization**.

---

### 🧪 Types of Variables

|Variable Type|Description|Example|
|---|---|---|
|`string`|A single string value|`"eastus"`|
|`number`|A numeric value|`2`, `5.5`|
|`bool`|A true/false value|`true`, `false`|
|`list`|An ordered list of values|`["a", "b", "c"]`|
|`map`|A key-value pair object|`{ env = "dev", tier = "1" }`|
|`set`|Unordered collection of values|`["x", "y"]`|
|`object`|Structured group of key-values|`{name="app", size="small"}`|

---

### 📦 Defining Variables

#### `variables.tf` or any `.tf` file:

```hcl
variable "location" {
  type        = string
  description = "Azure region for resources"
  default     = "eastus"
}
```

---

### 🛠 Using Variables in Code

```hcl
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.environment}"
  location = var.location
}
```

---

### 📁 Providing Values

|Method|File/Command|Example|
|---|---|---|
|Default value|Defined in variable block|`default = "eastus"`|
|`terraform.tfvars` file|Auto-loaded by Terraform|`location = "centralus"`|
|`*.auto.tfvars` files|Auto-loaded by Terraform|`prod.auto.tfvars`|
|Command line `-var`|Override variable|`-var="location=westus"`|
|Command line `-var-file`|Use custom var file|`-var-file="dev.tfvars"`|
|Environment variables|Use `TF_VAR_` prefix|`export TF_VAR_location=centralus`|

---

### 🔐 Sensitive Variables

```hcl
variable "admin_password" {
  type      = string
  sensitive = true
}
```

This prevents the value from being displayed in logs or CLI output.

---

### 🧠 Example: Full Setup

**variables.tf**

```hcl
variable "location" {
  type    = string
  default = "eastus"
}
```

**terraform.tfvars**

```hcl
location = "centralus"
```

**main.tf**

```hcl
resource "azurerm_resource_group" "main" {
  name     = "rg-demo"
  location = var.location
}
```

---

Would you like me to:

- 📇 Generate **flashcards** for this topic now?
    
- 💾 Provide a **ZIP with variable usage examples**?
    
- Or move to **Topic 8: Outputs**?
    

Let me know!