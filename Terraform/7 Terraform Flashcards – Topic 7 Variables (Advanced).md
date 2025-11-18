
## 📇 Flashcards in Markdown Format (Notion-Friendly)

---

# 🎴 Terraform Flashcards – Topic 7: Variables (Advanced)

---

- **Map** is a loosely-typed key-value structure, suitable for dynamic keys.
    
- **Object** is a strictly-typed structure, useful when the input structure must be enforced.
    

---

- Use `map` for dynamic values like tags or key-value configs.
    
- Use `object` for fixed structures like VM config or structured credentials.
    

---

- Hides variable value in CLI output
    
- Still stored in state files
    
- Helps prevent secret leakage in logs
    

---

- Better organization
    
- Easier collaboration
    
- Cleaner logic and input separation
    

---

```hcl
variable "vm_settings" {
  type = object({
    name     = string
    size     = string
    location = string
  })
}
```

---

```hcl
variable "tags" {
  type = map(string)
}
```

---

```hcl
variable "admin_password" {
  type      = string
  sensitive = true
}
```

---

Would you like a downloadable ZIP of this flashcard + working examples? Or shall we proceed with **Topic 8: Outputs**?