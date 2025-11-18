Awesome! Let's move on to **📘 Topic 19: Terraform Targeting and Dependency Management** and generate **Notion-friendly flashcards** at the end.

---

## ✅ **Topic 19: Terraform Targeting (`-target`) and Dependency Management**

Terraform builds resources **based on dependencies**, unless you **explicitly target** specific ones. Understanding targeting helps during troubleshooting, selective deployments, or module-level changes.

---

### 🎯 `terraform apply -target=RESOURCE`

- **Purpose:** Used to **apply only specific resources** (or modules).
    
- Useful for **testing individual components** or **faster debugging**.
    
- **Not recommended for normal use** – can cause drift or dependency issues.
    

---

### 🧩 **Dependency Management in Terraform**

Terraform builds a **resource dependency graph**:

- Automatically knows which resource to create/destroy **first**.
    
- Uses:
    
    - **Implicit dependencies**: via attribute references
        
    - **Explicit dependencies**: via `depends_on`
        

#### ✅ Example of Implicit Dependency:

```hcl
resource "azurerm_network_interface" "nic" {
  subnet_id = azurerm_subnet.subnet.id
}
```

#### ✅ Example of Explicit Dependency:

```hcl
resource "null_resource" "example" {
  depends_on = [azurerm_virtual_machine.vm]
}
```

---

### 🔍 Use Cases for `-target`

|Scenario|Example|
|---|---|
|Apply only storage account|`terraform apply -target=azurerm_storage_account.example`|
|Apply a module|`terraform apply -target=module.network`|
|Debug VM creation errors|`terraform apply -target=azurerm_linux_virtual_machine.vm1`|

> ⚠️ **Avoid using `-target` in CI/CD** pipelines; it bypasses Terraform's full planning.

---

### 🔗 Dependency Pitfalls

- Forgetting to reference a resource = no dependency!
    
- Breaking implicit dependency = wrong order of execution.
    
- Using `depends_on` on data sources has **no effect**.
    
