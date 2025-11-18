Here's **Terraform Learning Plan: Topic 29 – Sentinel Policies**, fully elaborated with **5 real-world Azure examples** and **Notion-friendly Markdown flashcards**.

---

# 🛡️ Topic 29: Sentinel Policies in Terraform (Advanced Governance for Azure)

---

## 📘 What is Sentinel?

**Sentinel** is a **Policy-as-Code (PaC) framework** by HashiCorp, integrated with Terraform Enterprise and Terraform Cloud. It enables enforcing **custom rules and governance** before infrastructure changes are applied.

🔐 Sentinel lets organizations **prevent misconfigurations** and **enforce compliance** without manually reviewing code.

---

## ⚙️ How Sentinel Works

1. Terraform Cloud/Enterprise runs Sentinel **after the plan** but **before apply**.
    
2. Sentinel evaluates the plan using defined **policies**.
    
3. Policies can `pass`, `warn`, or `fail`.
    
4. Apply proceeds only if policies are passed (or warnings are allowed).
    

---

## 🧱 Key Sentinel Concepts

|Concept|Description|
|---|---|
|Policy|A script written in Sentinel language (.sentinel file)|
|Rule|A conditional check inside the policy|
|Enforcement Level|`hard-mandatory`, `soft-mandatory`, or `advisory`|
|Import|Data source like `tfplan`, `tfstate`, `tfrun`|
|Mocking|Simulated inputs for testing Sentinel policies|

---

## 🧪 Example Sentinel Policy

```hcl
import "tfplan/v2" as tfplan

main = rule {
  all tfplan.resource_changes as rc {
    rc.type is not "azurerm_public_ip"
  }
}
```

✔ Prevents creation of public IPs.

---

## ✅ Real-World Azure Use Cases

---

### 🔒 Example 1: Deny Public IP Creation

```hcl
import "tfplan/v2" as tfplan

main = rule {
  all tfplan.resource_changes as rc {
    rc.type is not "azurerm_public_ip"
  }
}
```

💡 Prevents exposing services on the internet by mistake.

---

### ☁️ Example 2: Enforce Use of Tags

```hcl
import "tfplan/v2" as tfplan

main = rule {
  all tfplan.resource_changes as rc {
    all rc.change.after.tags as tag {
      tag contains "Environment"
    }
  }
}
```

💡 Ensures Azure cost management and governance is in place.

---

### 🏢 Example 3: Restrict VM Size in Production

```hcl
import "tfplan/v2" as tfplan

main = rule {
  all tfplan.resource_changes as rc {
    rc.type is "azurerm_linux_virtual_machine" and
    rc.change.after.tags["Environment"] is "prod" ->
    rc.change.after.size is "Standard_DS2_v2"
  }
}
```

💡 Controls costs and standardizes VM sizes in production.

---

### 🔐 Example 4: Enforce Storage Account Encryption

```hcl
import "tfplan/v2" as tfplan

main = rule {
  all tfplan.resource_changes as rc {
    rc.type is "azurerm_storage_account" ->
    rc.change.after.enable_https_traffic_only is true and
    rc.change.after.allow_blob_public_access is false
  }
}
```

💡 Ensures storage is secure and not publicly exposed.

---

### 🛑 Example 5: Block Resource Creation in Certain Regions

```hcl
import "tfplan/v2" as tfplan

main = rule {
  all tfplan.resource_changes as rc {
    not rc.change.after.location matches "eastus2"
  }
}
```

💡 Prevents accidental deployment to disallowed regions (e.g., for compliance reasons).

---

## 🔄 Enforcement Levels

|Level|Effect|
|---|---|
|`hard-mandatory`|Blocks the apply if policy fails|
|`soft-mandatory`|Allows apply with warning|
|`advisory`|Only logs the failure without blocking the apply|

---

## 👩‍💻 Workflow Integration

1. Write `.sentinel` policies.
    
2. Attach to workspace in **Terraform Cloud/Enterprise**.
    
3. Choose enforcement level.
    
4. Terraform plan runs → Sentinel policy evaluated → Apply blocked or allowed.
    

---

## 🧠 Sentinel Flashcards – Topic 29 (Markdown Format)

```markdown
# 📚 Terraform Flashcards – Topic 29: Sentinel Policies

## Flashcard 1
**Q:** What is Sentinel in the context of Terraform?  
**A:** Sentinel is a policy-as-code framework for enforcing governance in Terraform Cloud and Enterprise.

## Flashcard 2
**Q:** At which stage does Sentinel evaluate policies?  
**A:** After the Terraform plan but before the apply phase.

## Flashcard 3
**Q:** What are the enforcement levels in Sentinel?  
**A:** `hard-mandatory`, `soft-mandatory`, and `advisory`.

## Flashcard 4
**Q:** How does Sentinel access planned Terraform resources?  
**A:** Through imports like `tfplan`, `tfstate`, or `tfrun`.

## Flashcard 5
**Q:** Give an example of a common security policy in Sentinel.  
**A:** Prevent creation of `azurerm_public_ip` resources.

## Flashcard 6
**Q:** How does Sentinel help enforce tagging policies?  
**A:** By checking if resources include required tags in `rc.change.after.tags`.

## Flashcard 7
**Q:** Can Sentinel restrict Azure region deployments?  
**A:** Yes, by matching against `location` in planned resources.

## Flashcard 8
**Q:** Is Sentinel available in open-source Terraform?  
**A:** No, only in Terraform Cloud and Terraform Enterprise.

## Flashcard 9
**Q:** How can teams test Sentinel policies locally?  
**A:** By using mocks and the `sentinel` CLI for local testing.

## Flashcard 10
**Q:** Why use Sentinel over manual code reviews?  
**A:** It provides automated, consistent, and enforceable governance.
```

---

Would you like this added to your ZIP bundle or exported as a Notion database as well?