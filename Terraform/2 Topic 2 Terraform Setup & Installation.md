It seems like I can’t do more advanced data analysis right now. Please try again later.

For now, I’ll share **Topic 2: Terraform Setup & Installation** content here directly, including flashcard-style notes and examples. Once the tool is available again, I’ll generate and provide the downloadable PDF version.

---

## 🧠 **Terraform Topic 2: Setup & Installation**

### ✅ **Key Concepts (Flashcard Style)**

|❓ Question|✅ Answer|
|---|---|
|**How do you install Terraform on Windows?**|1. Download ZIP from terraform.io → 2. Extract → 3. Add folder to PATH → 4. Run `terraform -version`|
|**How to install on macOS/Linux?**|macOS: `brew install terraform` Ubuntu: Add HashiCorp repo, then `apt install terraform`|
|**How to verify Terraform installation?**|`terraform -version`|
|**What is `terraform init`?**|Initializes directory, downloads providers, creates `.terraform` folder|
|**How to configure Azure provider?**|`hcl\nprovider "azurerm" {\n features {}\n}`|
|**How to authenticate to Azure?**|- `az login` via Azure CLI - Environment variables - Service principal|
|**What is `.terraform.lock.hcl`?**|Lock file for provider versions to ensure consistent deployments|
|**Where should `.tf` files be located?**|In your project folder, typically named `main.tf`, `variables.tf`, etc.|

---

## 🔍 **3 Real-World Examples**

### 🔹 Example 1: Install & verify Terraform on Ubuntu

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
terraform -version
```

---

### 🔹 Example 2: Initialize a Terraform Azure project

```hcl
# main.tf
provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
```

Then run:

```bash
terraform init
```

---

### 🔹 Example 3: Authenticate Terraform to Azure using Service Principal

```bash
az ad sp create-for-rbac --name terraform-app --role="Contributor" \
  --scopes="/subscriptions/<your-subscription-id>" \
  --sdk-auth
```

Then set these environment variables:

```bash
export ARM_CLIENT_ID="xxx"
export ARM_CLIENT_SECRET="xxx"
export ARM_SUBSCRIPTION_ID="xxx"
export ARM_TENANT_ID="xxx"
```

---

Let me know if you'd like a Notion-ready version of this as well. When you’re ready, we can proceed to **Topic 3: Terraform Core Workflow (`init`, `plan`, `apply`, `destroy`)**.