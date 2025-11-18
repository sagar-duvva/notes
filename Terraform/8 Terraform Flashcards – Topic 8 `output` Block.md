Here are your **Terraform Output Block Flashcards** in **Notion-friendly Markdown format**:

---

### 📒 Terraform Flashcards – Topic 8: `output` Block

````markdown
# Terraform Flashcards – Topic 8: `output` Block

## Flashcard 1
**Q:** What is the purpose of the `output` block in Terraform?  
**A:** To display computed values after Terraform apply, such as IP addresses, resource names, or any useful result of the deployment.

---

## Flashcard 2
**Q:** What is the syntax of a basic `output` block?  
**A:**
```hcl
output "name" {
  value       = <expression>
  description = "Optional explanation"
  sensitive   = true|false
}
````

---

## Flashcard 3

**Q:** What does the `sensitive = true` attribute in `output` block do?  
**A:** Hides the output value from CLI output and logs, but the value is still stored in the state file.

---

## Flashcard 4

**Q:** Give an example of an output that shows a VM's public IP.  
**A:**

```hcl
output "vm_public_ip" {
  value = azurerm_public_ip.vm.ip_address
}
```

---

## Flashcard 5

**Q:** How do you access an output value from a module?  
**A:** `module.<module_name>.<output_name>`

Example:

```hcl
output "storage_name" {
  value = module.storage.storage_account_name
}
```

---

## Flashcard 6

**Q:** Which Terraform command shows all outputs after apply?  
**A:** `terraform output`  
Use `terraform output <name>` for a specific output.

---

## Flashcard 7

**Q:** Can outputs be used across modules?  
**A:** Yes, outputs can be exported from a module and consumed by the calling/root module.

---

## Flashcard 8

**Q:** Will `sensitive` outputs still be visible in the Terraform state file?  
**A:** Yes, `sensitive = true` hides values from logs and terminal but not from state files.

---

```

---

✅ Let me know if you'd like this bundled as a **.md file download** or if we should now proceed to **Topic 9: Data Sources**.
```