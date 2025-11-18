Great! Let's move ahead to **📘 Topic 14: Terraform Workspaces**.


## 🧠 Flashcards (Markdown Format, Notion-Friendly)

```markdown
## Terraform Workspaces 🧠

---

### ✅ What Are They?
Terraform Workspaces allow isolated state files using the same codebase.

---

### 🔹 Common Commands

- `terraform workspace list` → View all
- `terraform workspace new <name>` → Create
- `terraform workspace select <name>` → Switch
- `terraform workspace show` → Show current
- `terraform workspace delete <name>` → Delete

---

### 🔧 Use Cases

1. Isolate state for `dev`, `staging`, `prod`
2. Use `${terraform.workspace}` in naming
3. Conditional logic via `locals` or `variables`

---

### ⚠️ Limitations

- Not suitable for complex multi-env CI/CD
- Doesn't replace separate backends or pipelines
```

---

Would you like a **downloadable example project structure ZIP** showing how to use workspaces in a real Terraform setup? Or shall we proceed to **Topic 15: Provisioners**?