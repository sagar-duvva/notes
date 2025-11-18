Here’s your **Notion-friendly Markdown flashcard summary** of the concept:  
🧠 **"Does `terraform init` populate the state?"** and **"When and how data sources are evaluated"**

---

## 📚 Flashcards – Terraform State Initialization & Data Sources

````markdown
# Terraform State & Data Sources — Flashcards

## 💡 Flashcard 1: Does `terraform init` populate the state?
**Q:** Does `terraform init` populate the Terraform state?
**A:** ❌ No. `terraform init` only sets up the working directory and downloads providers/backends. It does **not fetch or evaluate resources**.

---

## 💡 Flashcard 2: What does `terraform init` actually do?
**Q:** What does `terraform init` do?
**A:** Initializes the working directory, downloads provider plugins, configures the backend, and prepares modules. It does not inspect infrastructure or create state files.

---

## 💡 Flashcard 3: When is Terraform state populated?
**Q:** When is Terraform state populated?
**A:** Terraform state is populated:
- In-memory during `terraform plan`
- Persistently in `.tfstate` during `terraform apply`

---

## 💡 Flashcard 4: When are `data` sources evaluated?
**Q:** When are Terraform `data` sources evaluated?
**A:** `data` sources are fetched during `terraform plan` and `terraform apply`. They are **not available** just after `terraform init`.

---

## 💡 Flashcard 5: Why do I need to run `terraform plan` before using `terraform console`?
**Q:** Why is `terraform plan` needed before using `terraform console` to inspect `data` sources?
**A:** Because `terraform console` can only show `data` source values **after they are fetched**. Running `plan` evaluates and loads them into memory.

---

## 💡 Flashcard 6: Summary Table – Init vs Plan vs Apply
| Command             | Sets Up Backend | Evaluates Config | Fetches Data Sources | Populates State File |
|---------------------|------------------|-------------------|------------------------|------------------------|
| `terraform init`    | ✅ Yes           | ❌ No            | ❌ No                 | ❌ No                 |
| `terraform plan`    | ✅ Yes           | ✅ Yes           | ✅ Yes                | ❌ No                 |
| `terraform apply`   | ✅ Yes           | ✅ Yes           | ✅ Yes                | ✅ Yes                |

---

## 💡 Flashcard 7: Example — `terraform console` error without plan
**Q:** What happens if you run `terraform console` before `terraform plan` with a data source?
**A:** You may get an error like `The given key does not identify an element...` because the data source hasn't been evaluated yet.

---

## 💡 Flashcard 8: Best Practice for Inspecting Resources
**Q:** What's the best practice to safely inspect outputs, variables, or data source values interactively?
**A:** Run:
```bash
terraform init
terraform plan
terraform console
````

Then you can safely use `terraform console` to explore data/outputs.

```

---

Would you like to move on to **Topic 10: Terraform Locals** now?
```