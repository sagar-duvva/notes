Awesome! Let's move on to **📘 Topic 19: Terraform Targeting and Dependency Management** and generate **Notion-friendly flashcards** at the end.

---

## 🧠 Flashcards – Markdown Format (Notion-Friendly)

````markdown
# 🧠 Terraform Flashcards – Topic 19: Targeting & Dependency Management

---

## 🔹 What is `terraform apply -target` used for?
To selectively apply only specific resources or modules during deployment.

---

## 🔹 Example command to apply only a single VM resource?
```bash
terraform apply -target=azurerm_linux_virtual_machine.vm1
````

---

## 🔹 Should you use `-target` in production pipelines?

No, it’s risky. It bypasses the complete dependency graph and can lead to drift.

---

## 🔹 What is Terraform’s dependency graph?

Terraform builds an execution plan by determining which resources depend on others.

---

## 🔹 How are implicit dependencies created?

By referencing another resource's attributes:

```hcl
subnet_id = azurerm_subnet.subnet.id
```

---

## 🔹 What is the purpose of `depends_on`?

To define **explicit dependencies** where Terraform wouldn’t detect it automatically.

---

## 🔹 Can `depends_on` be used with data sources?

Technically yes, but it has **no impact**, since data sources are read-only.

---

## 🔹 Example of using `depends_on`?

```hcl
resource "null_resource" "example" {
  depends_on = [azurerm_resource_group.rg]
}
```

---

## 🔹 What happens if dependency links are broken?

Terraform may apply resources in the wrong order or fail to plan correctly.

---

## 🔹 How does targeting affect state?

It can **update state partially**, leading to potential drift if misused.

```

---

Would you like a **ZIP with real Terraform examples for targeting and dependency handling** (e.g., multi-module project with selective applies)?

Shall we proceed to **Topic 20: Terraform Tainting and Resource Replacement**?
```