Great! Let's move ahead to **📘 Topic 14: Terraform Workspaces**.

---

## ✅ **Topic 14: Terraform Workspaces**

### 🔹 What Are Workspaces?

Workspaces allow you to **use the same Terraform configuration** for multiple **isolated state files**—typically used to manage different **environments** like `dev`, `staging`, `prod`, etc.

---

## 🧱 Why Use Workspaces?

- Isolate state files without changing code.
    
- Manage multiple environments using the same modules.
    
- Avoid duplication of infrastructure code.
    

---

## 🔧 Core Commands

|Command|Description|
|---|---|
|`terraform workspace list`|Show all workspaces|
|`terraform workspace new <name>`|Create a new workspace|
|`terraform workspace select <name>`|Switch to a workspace|
|`terraform workspace show`|Display the current workspace|
|`terraform workspace delete <name>`|Delete a workspace|

---

## 🧪 Examples

---

### ✅ **Example 1: Creating Workspaces for Different Environments**

```bash
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```

Now switch between them:

```bash
terraform workspace select prod
terraform apply
```

Each workspace keeps its own **state file** (e.g., `terraform.tfstate.d/prod/terraform.tfstate`).

---

### ✅ **Example 2: Use Workspaces in Resource Naming**

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-${terraform.workspace}"
  location = "eastus"
}
```

When running under `dev`, the resource group will be named `rg-dev`.

---

### ✅ **Example 3: Different Variables Based on Workspace**

Use a locals block to customize variables:

```hcl
locals {
  location = terraform.workspace == "prod" ? "eastus" : "westus"
}
```

---

### ⚠️ Workspace Limitations

- Workspaces **do not replace full environment separation** in complex use cases.
    
- Avoid relying solely on workspaces for production-grade multi-environment architectures; consider separate folders, backends, or pipelines instead.
    

---

## 🧠 Flashcards (Markdown Format, Notion-Friendly)

```markdown
## Terraform Workspaces 🧠

---

### ✅ What Are They?
Terraform Workspaces allow isolated state files using the same codebase.

---

### 🔹 Common Commands

- `terraform workspace list` → View all
- `terraform workspace new <name>` → Create
- `terraform workspace select <name>` → Switch
- `terraform workspace show` → Show current
- `terraform workspace delete <name>` → Delete

---

### 🔧 Use Cases

1. Isolate state for `dev`, `staging`, `prod`
2. Use `${terraform.workspace}` in naming
3. Conditional logic via `locals` or `variables`

---

### ⚠️ Limitations

- Not suitable for complex multi-env CI/CD
- Doesn't replace separate backends or pipelines
```

---

Would you like a **downloadable example project structure ZIP** showing how to use workspaces in a real Terraform setup? Or shall we proceed to **Topic 15: Provisioners**?





Here is the **downloadable ZIP** with a working Terraform folder structure that demonstrates **3 real-world workspace environments**:

🔽 [Download terraform_workspace_examples.zip](sandbox:/mnt/data/terraform_workspace_examples.zip)

### 👇 What's inside:

Each folder (`dev_workspace`, `staging_workspace`, `prod_workspace`) contains:

- `main.tf` — with backend and a dynamic resource group using `terraform.workspace`
    
- `variables.tf` — for location input
    

---

### ✅ Real-World Use Case Summary

**Use Case 1: Isolated Resource Groups per Environment**

- Resource group name becomes `rg-dev`, `rg-staging`, or `rg-prod` dynamically.
    

**Use Case 2: Clean Local State Separation**

- Each folder maintains its own `terraform.tfstate` via local backend.
    
- You can also migrate this to a remote backend with workspace support (e.g., Azure Storage + state key `${terraform.workspace}`).
    

**Use Case 3: DRY Code with Dynamic Names**

- Reduce duplication using interpolation with `terraform.workspace`.
    

You can now `cd` into each workspace directory and run:

```bash
terraform init
terraform workspace new <env-name>   # optional if using remote backend
terraform plan
terraform apply
```

---

Would you like a visual diagram or want to move on to the next topic: **Topic 15: Remote Backends**?


