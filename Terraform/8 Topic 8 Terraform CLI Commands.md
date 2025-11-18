Here’s your **✅ Topic 8: Terraform CLI Commands** explained in detail with **Azure real-world examples**, and a full set of **Notion-friendly Markdown flashcards**.

---

# ✅ Topic 8: Terraform CLI Commands

---

## 🧠 What is the Terraform CLI?

Terraform CLI (Command Line Interface) is the main way to interact with Terraform. It allows you to:

- Initialize Terraform config
    
- Validate and plan changes
    
- Apply infrastructure changes
    
- Destroy resources
    
- Manage state and more
    

---

## 🧰 Core Terraform CLI Commands (with Azure Examples)

---

### 🔹 `terraform init`

Initializes the Terraform configuration. Downloads providers like `azurerm`.

```bash
terraform init
```

📌 **Example**: When setting up your Azure project for the first time.

---

### 🔹 `terraform plan`

Shows what Terraform will do **before** making any changes.

```bash
terraform plan -out=tfplan
```

📌 **Example**: Use before applying to preview Azure resource changes, like adding a VM or changing SKU of App Service.

---

### 🔹 `terraform apply`

Applies the changes described by the configuration.

```bash
terraform apply tfplan
```

📌 **Example**: Deploys an Azure resource group, VNet, or Kubernetes cluster.

---

### 🔹 `terraform destroy`

Destroys all resources managed by Terraform.

```bash
terraform destroy
```

📌 **Example**: Clean up dev/test resources to avoid Azure billing.

---

### 🔹 `terraform fmt`

Formats Terraform files for consistent style.

```bash
terraform fmt
```

📌 **Example**: Run in pipelines to ensure `.tf` files are readable before code review.

---

### 🔹 `terraform validate`

Validates the syntax and structure of the `.tf` files.

```bash
terraform validate
```

📌 **Example**: Run this in CI/CD pipelines before `plan`.

---

### 🔹 `terraform taint` and `terraform untaint`

Marks a resource for recreation during the next apply.

```bash
terraform taint azurerm_virtual_machine.example
```

📌 **Example**: Rebuild an Azure VM due to corruption.

---

### 🔹 `terraform state`

Inspect and manipulate the Terraform state file.

```bash
terraform state list
terraform state show <resource>
```

📌 **Example**: Check what's currently managed in Azure by Terraform.

---

## 🏗️ 5 Real-World Azure Use Cases

---

### ✅ **1. Deploying Azure Kubernetes Service (AKS)**

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

📌 Efficient for reusable AKS deployments in CI/CD.

---

### ✅ **2. Destroying Test Infrastructure**

```bash
terraform destroy -auto-approve
```

📌 Helps save costs by destroying sandbox Azure VMs, App Services, etc.

---

### ✅ **3. Managing Infrastructure Drift**

```bash
terraform plan
```

📌 Identifies manual changes in Azure Portal and proposes corrections.

---

### ✅ **4. Recreate Broken Resource**

```bash
terraform taint azurerm_public_ip.myip
terraform apply
```

📌 Recreates only the IP instead of the entire infra.

---

### ✅ **5. Validating Terraform in DevSecOps Pipeline**

```bash
terraform fmt -check
terraform validate
```

📌 Part of static checks before Azure deployment pipeline runs.

---

## 📚 Terraform Flashcards – Topic 8: CLI Commands (Markdown – Notion Friendly)

```markdown
# 📚 Terraform Flashcards – Topic 8: CLI Commands

## Flashcard 1
**Q:** What does `terraform init` do?  
**A:** Initializes the working directory and downloads providers.

## Flashcard 2
**Q:** How do you preview Terraform changes without applying them?  
**A:** `terraform plan`

## Flashcard 3
**Q:** What is the command to apply a saved plan file?  
**A:** `terraform apply tfplan`

## Flashcard 4
**Q:** How do you remove all Azure resources managed by Terraform?  
**A:** `terraform destroy`

## Flashcard 5
**Q:** Which command ensures Terraform files are properly formatted?  
**A:** `terraform fmt`

## Flashcard 6
**Q:** What is `terraform validate` used for?  
**A:** To validate syntax and internal consistency of the configuration files.

## Flashcard 7
**Q:** How do you mark an Azure resource for recreation?  
**A:** `terraform taint <resource_name>`

## Flashcard 8
**Q:** What does `terraform state list` show?  
**A:** It lists all resources Terraform is managing.

## Flashcard 9
**Q:** Which command helps check if the configuration files are consistent in structure and logic?  
**A:** `terraform validate`

## Flashcard 10
**Q:** In what scenario would `terraform destroy` be useful in Azure?  
**A:** To clean up test resources to avoid billing.
```

---

### ✅ Would You Like Me To:

- Add this to the Markdown ZIP bundle?
    
- Generate a single PDF or Notion import file?
    
- Continue to **next topic** in the learning path?
    

Let me know, ByteBuddy’s ready to proceed!