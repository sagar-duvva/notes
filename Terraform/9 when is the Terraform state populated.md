Great question! Let's clarify this important concept step-by-step:

---

## 🔍 **Does `terraform init` populate the state?**

**No**, `terraform init` does **not** populate the Terraform state.

### ✅ What `terraform init` does:

- Initializes your working directory
    
- Downloads provider plugins
    
- Configures backends (like Azure Storage for remote state)
    
- Prepares modules
    

It **does not inspect existing infrastructure** or fetch current resource values — **state is still empty** at this point.

---

## 🔍 Then when is the state populated?

### ✅ Terraform state is populated during:

#### 1. `terraform plan`

- Evaluates configuration
    
- Queries any `data` sources (e.g., Azure Key Vault, existing resource groups)
    
- Computes the expected state
    
- Shows what will be created/updated/destroyed
    
- **Populates state in memory only**, but not saved to `.tfstate` file
    

#### 2. `terraform apply`

- Actually creates/updates infrastructure
    
- Saves new or updated resources to the **persistent `.tfstate` file**
    

---

## 🔍 Why do we say "`terraform plan` is needed especially for `data` sources"?

Because:

- `data` sources (e.g., `data.azurerm_resource_group.existing`) **fetch information from real cloud infrastructure**
    
- When you run `terraform console`, Terraform can only evaluate them **if they have already been queried** during `plan`
    
- Otherwise, in `terraform console`, the `data` source might not exist yet, or return incomplete results
    

---

### 🧪 Example:

#### Scenario:

You have this in your config:

```hcl
data "azurerm_resource_group" "existing" {
  name = "my-rg"
}
```

#### You run:

```bash
terraform init
terraform console
> data.azurerm_resource_group.existing.location
```

✅ You’ll likely get an error like:

```
The given key does not identify an element in this collection value.
```

#### But if you run:

```bash
terraform plan
terraform console
> data.azurerm_resource_group.existing.location
```

✅ Now it works! Because Terraform has **fetched the data during plan**, and knows what value to show.

---

## ✅ Summary

|Command|Populates `.terraform`?|Populates State in Memory?|Writes `.tfstate`?|Fetches Data Sources?|
|---|---|---|---|---|
|`terraform init`|✅ Yes|❌ No|❌ No|❌ No|
|`terraform plan`|✅ Yes (checks config)|✅ Yes|❌ No|✅ Yes|
|`terraform apply`|✅ Yes|✅ Yes|✅ Yes|✅ Yes|

---

Would you like this as a **flashcard summary** before we move to **Topic 10: Locals**?