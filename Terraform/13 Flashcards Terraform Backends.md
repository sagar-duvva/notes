
## 🧠 Flashcards: Terraform Backends (Markdown, Notion-Ready)

```markdown
# Terraform Backends Flashcards

## Q1: What is a backend in Terraform?
It defines where and how Terraform stores and accesses the state file (`terraform.tfstate`).

## Q2: What are the benefits of remote backends?
- Team collaboration
- State locking
- Centralized storage
- Improved security

## Q3: What are some common backend types?
- `local` (default)
- `azurerm` (Azure)
- `s3` (AWS)
- `gcs` (Google Cloud)
- `http` / `remote` / Terraform Cloud

## Q4: How to configure a backend in Terraform?
Use `terraform { backend "..." { ... } }` block in a `.tf` file and run `terraform init`.

## Q5: Can backend config include sensitive info?
No. Use `terraform init -backend-config` CLI flags or env vars to inject securely.

## Q6: Does changing a backend require reinitialization?
Yes. You must re-run `terraform init` to reconfigure or migrate the backend.

## Q7: What is state locking?
A mechanism to prevent concurrent changes to state files (supported in most remote backends).

## Q8: Can backends be defined per environment?
Yes. Use different `key` values or separate containers/buckets for each env (prod, staging, etc).

## Q9: Why avoid hardcoding backend configs?
To maintain flexibility and avoid exposing sensitive values.

## Q10: When is backend initialized?
During `terraform init`. It reads and configures the backend settings.

```

---

Would you like a **ZIP package** of the sample backend configuration as well before we move on to **Topic 14: Providers**?