### ✅ **Topic 15: Remote Backends in Terraform**

---

Remote backends allow you to **store Terraform state files remotely** instead of locally. This enables **team collaboration, state locking, and better security**.

---

## 📘 What Is a Remote Backend?

In Terraform, a backend determines _how state is loaded and where it is stored_. Remote backends like **Azure Storage**, **S3**, **Terraform Cloud**, etc., allow:

- Collaboration with shared state
    
- Locking (to prevent concurrent writes)
    
- Secure storage
    
- Versioning
    

---

## 🌍 Common Remote Backends

|Backend Type|Use Case|Supports Locking?|
|---|---|---|
|`azurerm`|Store state in Azure Storage|✅ Yes|
|`s3` + `dynamodb`|Store state in AWS + Locking|✅ Yes|
|`gcs`|Store state in Google Cloud Storage|✅ Yes|
|`http`|Store to an HTTP endpoint|❌ No|
|`terraform`|Terraform Cloud/Enterprise|✅ Yes|

---

## 🔧 Example: Azure Remote Backend

### `backend.tf`

```hcl
terraform {
  backend "azurerm" {
    resource_group_name   = "tfstate-rg"
    storage_account_name  = "tfstate123"
    container_name        = "tfstate"
    key                   = "prod.terraform.tfstate"
  }
}
```

> Use `terraform init -backend-config="..."` to pass sensitive values like access keys if needed.

---

## ✅ Real-World Example #1: Configure Azure Remote Backend

### Files:

```bash
project/
├── main.tf
├── backend.tf
└── variables.tf
```

### `backend.tf`

```hcl
terraform {
  backend "azurerm" {
    resource_group_name   = "rg-terraform"
    storage_account_name  = "tfstorageacct"
    container_name        = "tfstate"
    key                   = "dev/terraform.tfstate"
  }
}
```

---

## ✅ Real-World Example #2: Multiple Env State Keys (prod/staging/dev)

```hcl
key = "${terraform.workspace}/terraform.tfstate"
```

- `terraform workspace select prod` ➝ stores state in `prod/terraform.tfstate`
    
- `terraform workspace select dev` ➝ stores state in `dev/terraform.tfstate`
    

---

## ✅ Real-World Example #3: Passing Backend Config at Init

```bash
terraform init \
  -backend-config="resource_group_name=rg-terraform" \
  -backend-config="storage_account_name=tfstorageacct" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=staging.terraform.tfstate"
```

> Useful for CI/CD pipelines or script-based automation.

---

## ✅ Real-World Example #4: S3 Backend with DynamoDB Locking

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-states"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

---

## ✅ Real-World Example #5: Terraform Cloud Backend

```hcl
terraform {
  backend "remote" {
    organization = "my-org"

    workspaces {
      name = "dev-infra"
    }
  }
}
```

---

Would you like a **diagram + downloadable ZIP** showing these 5 backend configurations with real folders and working `.tf` files?

Or shall I proceed to generate **Flashcards in Markdown format (Notion-friendly)** for this topic?