Great follow-up! Let's explore both topics in detail:

---

## 🧱 2️⃣ How to Avoid Hardcoding Resource Attributes (Best Practice)

### ❌ Bad Practice: Hardcoding Attributes

```hcl
resource "azurerm_app_service" "webapp" {
  location = "eastus"           # hardcoded
  resource_group_name = "my-rg" # hardcoded
}
```

### ✅ Good Practice: Use `data` sources

#### Step 1: Fetch Resource Group dynamically

```hcl
data "azurerm_resource_group" "existing" {
  name = "my-rg"
}
```

#### Step 2: Reference values instead of hardcoding

```hcl
resource "azurerm_app_service" "webapp" {
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
}
```

---

### 🎯 Benefits of Fetching Dynamically

|Benefit|Explanation|
|---|---|
|🔁 Environment Agnostic|Works across dev, QA, prod|
|🛡️ Avoids Human Error|Prevents typos in names/locations|
|🔄 Automatically Tracks Changes|Updates if the resource was modified externally|
|💼 Reusable Modules|Pass references to modules, rather than fixed values|

---

### 💡 Bonus Tip

You can also combine `terraform console` and `data` to discover hidden fields:

```bash
terraform console
> data.azurerm_storage_account.example
```

Explore what fields are available, like:

- `primary_blob_endpoint`
    
- `primary_access_key`
    
- `tags`
    

---

Would you like this in flashcard format or shall we proceed to **Topic 10: Terraform Locals**?