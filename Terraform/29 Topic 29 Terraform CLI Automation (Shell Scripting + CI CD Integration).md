Great, ByteBuddy here again! Let's dive into  
**✅ Topic 29: Terraform CLI Automation (Shell Scripting + CI/CD Integration)**  
Then I’ll generate **Notion-ready Markdown flashcards**.

---

# ✅ **Topic 29: Terraform CLI Automation (Shell Scripting + CI/CD)**

---

## 🧰 Why Automate Terraform?

Automation helps:

- Reduce human error
    
- Standardize workflows
    
- Enable CI/CD pipelines for Infra-as-Code
    
- Improve collaboration in teams
    

---

## ⚙️ Automating Terraform with Shell Scripts

### 🧾 Sample Script: `deploy.sh`

```bash
#!/bin/bash

set -e

echo "Initializing Terraform..."
terraform init -backend-config="backend.tfvars"

echo "Validating Terraform files..."
terraform validate

echo "Planning changes..."
terraform plan -var-file="dev.tfvars" -out="tfplan.out"

echo "Applying changes..."
terraform apply "tfplan.out"
```

### 📌 Best Practices:

- Use `set -e` to exit on failure
    
- Separate plans (`.tfvars`) for different environments
    
- Use logging and exit codes in production-grade scripts
    

---

## 🚀 CI/CD Integration with GitHub Actions

### 📘 Sample: `.github/workflows/terraform.yml`

```yaml
name: Terraform Plan & Apply

on:
  push:
    branches:
      - main

jobs:
  terraform:
    name: Terraform Workflow
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.6.6

      - name: Terraform Init
        run: terraform init

      - name: Terraform Validate
        run: terraform validate

      - name: Terraform Plan
        run: terraform plan -out=tfplan.out

      - name: Terraform Apply (Auto Approved)
        if: github.ref == 'refs/heads/main'
        run: terraform apply -auto-approve tfplan.out
```

---

## 🧪 Integration with Azure DevOps Pipelines

### 📘 `azure-pipelines.yml`

```yaml
trigger:
  branches:
    include:
      - main

pool:
  vmImage: 'ubuntu-latest'

steps:
- task: TerraformInstaller@1
  inputs:
    terraformVersion: '1.6.6'

- script: terraform init
  displayName: 'Terraform Init'

- script: terraform validate
  displayName: 'Terraform Validate'

- script: terraform plan -out=tfplan.out
  displayName: 'Terraform Plan'

- script: terraform apply -auto-approve tfplan.out
  displayName: 'Terraform Apply'
```

---

## ✅ Best Practices for Terraform Automation

|Practice|Why It’s Important|
|---|---|
|Use Remote Backends|Avoids local state corruption|
|Enable Plan Review in CI|Prevents blind `apply` from running|
|Use Workspaces|Helps manage multiple environments|
|Encrypt Secrets|Avoid leaking sensitive data (use Azure Key Vault, GitHub Secrets)|

---

## 🧠 Flashcards: Terraform CLI Automation (Markdown - Notion Friendly)

```markdown
# 📚 Terraform Flashcards – Topic 29: CLI Automation (Shell + CI/CD)

## Flashcard 1
**Q:** Why is Terraform CLI automation important?  
**A:** It standardizes workflows, reduces manual errors, and enables CI/CD for infrastructure.

## Flashcard 2
**Q:** What does `set -e` do in a shell script?  
**A:** It stops the script execution if any command fails.

## Flashcard 3
**Q:** What are key steps in a Terraform automation script?  
**A:** `init`, `validate`, `plan`, and `apply`.

## Flashcard 4
**Q:** What’s a `.tfvars` file used for in scripts?  
**A:** To pass environment-specific variables to `terraform plan` or `apply`.

## Flashcard 5
**Q:** Which GitHub Action is used to install Terraform?  
**A:** `hashicorp/setup-terraform@v2`

## Flashcard 6
**Q:** How can you ensure `apply` only runs on the `main` branch in GitHub Actions?  
**A:** Use a conditional check: `if: github.ref == 'refs/heads/main'`

## Flashcard 7
**Q:** What are common stages in a GitHub Terraform CI/CD workflow?  
**A:** Checkout, setup Terraform, init, validate, plan, and apply.

## Flashcard 8
**Q:** Which YAML file defines pipelines in Azure DevOps?  
**A:** `azure-pipelines.yml`

## Flashcard 9
**Q:** What are some best practices for Terraform automation?  
**A:** Use remote backends, plan reviews, workspaces, and secure secrets.

## Flashcard 10
**Q:** Why should secrets be encrypted in CI/CD pipelines?  
**A:** To prevent credential leaks and secure infrastructure access.
```

---

Shall we now proceed to the final **Topic 30: Real-world Terraform Folder Structures & GitHub Repo Practices** and generate flashcards for that too?