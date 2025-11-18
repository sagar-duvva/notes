Here's the **Notion-friendly Markdown Flashcards** for **Topic 15: Remote Backends in Terraform** – ideal for reviewing or importing into Notion.

---

### ✅ Flashcards: Remote Backends in Terraform (`remote-backends.md`)

````markdown
# 🧠 Terraform Flashcards: Remote Backends

---

## Q: What is a backend in Terraform?
A: A backend in Terraform determines how state is loaded and how an operation like `apply` is executed. It can be local or remote.

---

## Q: What is a remote backend used for?
A: A remote backend stores the Terraform state file in a remote, shared location for better collaboration, locking, security, and consistency.

---

## Q: Name 5 commonly used remote backends.
A:
1. `azurerm` - Azure Storage Account
2. `s3` - AWS S3 (with DynamoDB for locking)
3. `gcs` - Google Cloud Storage
4. `terraform` - Terraform Cloud/Enterprise
5. `http` - Generic HTTP endpoints (no locking)

---

## Q: What is state locking in remote backends?
A: State locking prevents concurrent operations from corrupting the state file. Most remote backends (e.g., S3 with DynamoDB, azurerm) support it.

---

## Q: Example syntax for setting remote backend (Azure)?
A:
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "tfstorageacct"
    container_name       = "tfstate"
    key                  = "prod/terraform.tfstate"
  }
}
````

---

## Q: How do you initialize Terraform with backend configuration?

A:

```bash
terraform init \
  -backend-config="resource_group_name=rg-terraform" \
  -backend-config="storage_account_name=tfstorageacct" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=staging.tfstate"
```

---

## Q: How to use a dynamic key with multiple environments?

A:

```hcl
key = "${terraform.workspace}/terraform.tfstate"
```

Each workspace gets its own state file.

---

## Q: What does Terraform Cloud backend look like?

A:

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

## Q: Which backend supports encryption at rest and locking?

A: Most cloud provider backends like Azure (azurerm), AWS (S3 + DynamoDB), and GCP (GCS) support encryption and locking.

---

## Q: Why use remote backends instead of local state?

A: To enable team collaboration, secure and versioned state management, and to prevent local file corruption or accidental deletion.

---

```

---

Would you like me to now generate the **working ZIP file with Terraform backend configurations** across 5 real-world scenarios for hands-on practice?

Or shall we proceed to **Topic 16: Terraform State Management**?
```