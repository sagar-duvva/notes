Here are your **Terraform Flashcards – Topic 9: `data` Sources** in **Notion-friendly Markdown format**:

---

````markdown
# 📘 Terraform Flashcards – Topic 9: `data` Sources

## Flashcard 1
**Q:** What is the purpose of the `data` block in Terraform?  
**A:** It allows Terraform to **read** information from existing infrastructure or provider services without creating resources.

---

## Flashcard 2  
**Q:** What is the general syntax of a `data` block?  
**A:**
```hcl
data "<PROVIDER>_<RESOURCE_TYPE>" "<NAME>" {
  # arguments
}
````

---

## Flashcard 3

**Q:** How do you reference a value from a `data` block?  
**A:** Use `data.<PROVIDER>_<RESOURCE_TYPE>.<NAME>.<ATTRIBUTE>`

Example:

```hcl
data.azurerm_resource_group.my_rg.location
```

---

## Flashcard 4

**Q:** What is the difference between `data` and `resource` blocks in Terraform?  
**A:**

|Feature|`resource`|`data`|
|---|---|---|
|Purpose|Creates infrastructure|Reads existing infrastructure|
|Managed?|Yes|No (read-only)|
|Example|Create a VM, Key Vault, Storage|Read a secret, Resource Group, etc.|

---

## Flashcard 5

**Q:** Can `data` sources be used to fetch secrets from Azure Key Vault?  
**A:** Yes, using `azurerm_key_vault_secret` with a linked `azurerm_key_vault` data source.

Example:

```hcl
data "azurerm_key_vault_secret" "my_secret" {
  name         = "my-key"
  key_vault_id = data.azurerm_key_vault.example.id
}
```

---

## Flashcard 6

**Q:** Give an example of reading an existing Azure Resource Group.  
**A:**

```hcl
data "azurerm_resource_group" "existing" {
  name = "prod-rg"
}
```

---

## Flashcard 7

**Q:** Is a `data` source managed by Terraform?  
**A:** No. Terraform does not manage or modify data sources — it only reads them during the plan/apply phase.

---

## Flashcard 8

**Q:** How does using `data` sources make Terraform code more dynamic and reusable?  
**A:** It removes hardcoded values and makes the configuration adapt to existing environments or external systems.

---

## Flashcard 9

**Q:** Can `data` blocks be combined with `locals` or `outputs`?  
**A:** Yes. You can store values from `data` blocks in `locals`, or display them using `outputs`.

---

## Flashcard 10

**Q:** Which command helps inspect available outputs from data blocks?  
**A:** Use `terraform console` to explore structure and values.

---

```

---

Would you like a downloadable `.md` file or should we now proceed to **Topic 10: Terraform Locals**?
```