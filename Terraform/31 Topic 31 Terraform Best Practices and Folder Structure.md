Here’s **Topic 31: Terraform Best Practices and Folder Structure** explained in detail with **5 real-world Azure Cloud examples**, followed by **Notion-friendly flashcards** in **Markdown format**.

---

## 🌟 Topic 31: Terraform Best Practices and Folder Structure

Terraform code can quickly grow complex. To ensure maintainability, scalability, and security, it's critical to follow best practices and adopt a clean folder structure — especially in enterprise-grade Azure projects.

---

### ✅ Core Best Practices

|Category|Best Practice|
|---|---|
|Code Organization|Split into modules for reusability|
|State Management|Use remote backend (Azure Storage) with locking|
|Variable Management|Use `variables.tf`, `terraform.tfvars`, and keep secrets in Azure Key Vault|
|Sensitive Data|Use `sensitive = true`, never hardcode secrets|
|Versioning|Pin provider and Terraform versions|
|DRY Principle|Use locals and modules to avoid repetition|
|Naming Conventions|Consistent, readable naming (e.g., `rg-web-prod-001`)|
|Automation|Use CI/CD pipelines (GitHub Actions, Azure DevOps)|
|Format & Validate|Run `terraform fmt` and `terraform validate` regularly|
|Documentation|Add README, variable descriptions, and usage instructions|

---

### 📁 Folder Structure (Recommended)

```
project-root/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── backend.tf
├── versions.tf
├── README.md
│
├── modules/
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── compute/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── environments/
│   ├── dev/
│   │   └── terraform.tfvars
│   ├── stage/
│   │   └── terraform.tfvars
│   └── prod/
│       └── terraform.tfvars
```

---

## 🔍 5 Real-World Azure Examples

---

### **Example 1: Modularizing VNet, NSG, and Subnets**

- Split `network` into a module with inputs for address space, subnets, and NSGs.
    
- Reuse across dev, stage, prod.
    
- Ensures consistency and simplifies changes across environments.
    

---

### **Example 2: Secure State Management**

- Use `azurerm` backend with:
    
    - Azure Storage Account
        
    - Container: `tfstate`
        
    - Enable state locking via Azure Blob Lease
        
- Prevents conflicts during parallel execution.
    

---

### **Example 3: Managing Secrets Securely**

- Store client secrets and passwords in Azure Key Vault.
    
- Reference via `data "azurerm_key_vault_secret"` instead of hardcoding in `terraform.tfvars`.
    

---

### **Example 4: Automating Terraform with GitHub Actions**

- Use GitHub Actions workflow:
    
    - Run `terraform fmt`, `init`, `validate`, `plan`, `apply`
        
    - Enforce approvals before `apply` for production.
        

---

### **Example 5: Using Environment-Specific `tfvars`**

- `dev/terraform.tfvars`, `stage/terraform.tfvars`, etc.
    
- Parameterize region, VM size, replica count.
    
- Switch environments via CLI:
    
    ```bash
    terraform apply -var-file=environments/dev/terraform.tfvars
    ```
    

---

## 🧠 Flashcards – Topic 31: Terraform Best Practices and Folder Structure

```markdown
# 📘 Terraform Flashcards – Topic 31: Best Practices & Folder Structure

## Flashcard 1
**Q:** Why should you use modules in Terraform projects?
**A:** To promote reusability, consistency, and separation of concerns across infrastructure components like network, compute, etc.

## Flashcard 2
**Q:** What is a good way to manage sensitive variables like passwords?
**A:** Store them in Azure Key Vault and reference them in Terraform using `data "azurerm_key_vault_secret"`.

## Flashcard 3
**Q:** What backend is recommended for Terraform state management in Azure?
**A:** Azure Storage Account with Blob container, using `azurerm` backend and enabling locking via blob lease.

## Flashcard 4
**Q:** How do you handle multiple environments (dev, stage, prod) in Terraform?
**A:** Use separate `terraform.tfvars` files under `environments/` directory and apply using `-var-file`.

## Flashcard 5
**Q:** What automation practices improve Terraform quality?
**A:** Use CI/CD to automate linting (`fmt`), validation, plan, and apply steps, with approval gates for production.

## Flashcard 6
**Q:** What command ensures your Terraform code is formatted consistently?
**A:** `terraform fmt`

## Flashcard 7
**Q:** Where should your root-level Terraform files be placed?
**A:** In the project root directory (`main.tf`, `variables.tf`, `outputs.tf`, etc.), with modules and environments in subfolders.
```

---

Would you like this in a **Notion importable Markdown ZIP** or combined with the rest of your Terraform flashcards?