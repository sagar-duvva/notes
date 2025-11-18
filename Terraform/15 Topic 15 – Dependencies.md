Here’s your **Terraform Learning Plan: Topic 15 – Dependencies**, fully elaborated with **5 Azure-focused real-world examples** and **Notion-friendly Markdown flashcards**.

---

# ✅ Topic 15: **Terraform Dependencies**

---

## 🧠 What Are Dependencies in Terraform?

In Terraform, **dependencies** determine the **order of resource creation**, updates, or destruction.

Terraform automatically detects **implicit dependencies** by analyzing references between resources. For **manual control**, you can define **explicit dependencies** using the `depends_on` argument.

---

## 🔁 Dependency Types

|Type|Description|
|---|---|
|**Implicit**|Automatically inferred by referencing attributes from another resource|
|**Explicit**|Manually defined using `depends_on` when there’s no direct reference|
|**Module Dependencies**|Dependencies between modules via inputs and outputs|
|**Data Sources**|Data dependencies that must be fetched before provisioning|

---

## ☁️ 5 Real-World Azure Examples of Dependencies

---

### ✅ Example 1: **Implicit Dependency – Storage Container after Storage Account**

```hcl
resource "azurerm_storage_account" "main" {
  name                     = "tfexamplestorage"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "tfcontainer"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}
```

**Why it works:**  
Terraform sees that `azurerm_storage_container` references the account name from `azurerm_storage_account`, and will create the storage account first.

---

### ✅ Example 2: **Explicit Dependency – NSG applied after Subnet**

```hcl
resource "azurerm_network_security_group" "nsg" {
  name                = "web-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on                = [azurerm_subnet.web]
}
```

**Why it works:**  
Though Terraform _might_ infer the dependency, we add `depends_on` to be explicit, ensuring the subnet is ready before association.

---

### ✅ Example 3: **Output Dependency Between Modules**

```hcl
module "networking" {
  source              = "./modules/network"
  resource_group_name = var.resource_group
}

module "vm" {
  source              = "./modules/vm"
  subnet_id           = module.networking.subnet_id
}
```

**Why it works:**  
VM module depends on output (`subnet_id`) from `networking` module. Terraform recognizes this and creates the modules in the correct order.

---

### ✅ Example 4: **Data Source Dependency**

```hcl
data "azurerm_resource_group" "example" {
  name = "existing-rg"
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "log-analytics"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
}
```

**Why it works:**  
Terraform waits for data source `azurerm_resource_group` to resolve before using its output for the workspace creation.

---

### ✅ Example 5: **Force Resource Order in Same Resource Group**

```hcl
resource "azurerm_resource_group" "main" {
  name     = "rg-demo"
  location = "East US"
}

resource "azurerm_log_analytics_workspace" "logs" {
  name                = "demo-logs"
  location            = "East US"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_monitor_diagnostic_setting" "diag" {
  name                       = "diag-settings"
  target_resource_id         = azurerm_storage_account.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id
  depends_on                 = [azurerm_log_analytics_workspace.logs]
}
```

**Why it works:**  
The `depends_on` ensures the diagnostic setting waits for the Log Analytics workspace—even if outputs were indirectly linked.

---

## ⚙️ Best Practices

- Prefer **implicit dependencies** for clarity and simplicity
    
- Use `depends_on` only when:
    
    - There is **no attribute reference**, or
        
    - Terraform fails to recognize the correct order
        
- Avoid **circular dependencies** (e.g., two resources referencing each other)
    

---

## 📚 Terraform Flashcards – Topic 15: Dependencies (Markdown – Notion Friendly)

```markdown
# 📚 Terraform Flashcards – Topic 15: Dependencies

## Flashcard 1
**Q:** What is an implicit dependency in Terraform?  
**A:** A dependency inferred when one resource references another’s attribute.

## Flashcard 2
**Q:** When do you use `depends_on` in Terraform?  
**A:** When a dependency isn't automatically inferred or when explicit ordering is required.

## Flashcard 3
**Q:** Give an example of a data source dependency in Terraform.  
**A:** Using `data.azurerm_resource_group` before creating dependent resources like Log Analytics.

## Flashcard 4
**Q:** What kind of dependency is created when a module output is used in another module?  
**A:** An implicit module-to-module dependency.

## Flashcard 5
**Q:** Can you use `depends_on` with modules?  
**A:** Yes, `depends_on` can be used to manage module execution order.

## Flashcard 6
**Q:** Why are circular dependencies a problem in Terraform?  
**A:** They cause Terraform to fail since it can't determine a creation order.

## Flashcard 7
**Q:** In Azure, why might you use `depends_on` for NSG subnet association?  
**A:** To ensure the subnet is fully provisioned before linking the NSG.

## Flashcard 8
**Q:** How does Terraform determine the correct order of execution?  
**A:** Through its internal dependency graph based on references and `depends_on`.

## Flashcard 9
**Q:** Is `depends_on` required for all dependencies?  
**A:** No, use it only when Terraform can't infer the correct order.

## Flashcard 10
**Q:** What happens if two resources don’t depend on each other?  
**A:** Terraform may create them in parallel to optimize performance.
```

---

Would you like to:

- Bundle this into your Markdown ZIP?
    
- See the Terraform Graph (`terraform graph | dot`) for a sample project?
    
- Generate visual dependency diagrams?
    

Let me know how you'd like to extend this!