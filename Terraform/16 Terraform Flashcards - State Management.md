Here are your **🧠 Terraform State Management Flashcards** in **Markdown format**, perfect for Notion:

---

## 📚 Terraform Flashcards: State Management (Topic 16)

---

### Flashcard 1

**Q:** What is `terraform.tfstate`?  
**A:** It's the file Terraform uses to track infrastructure it manages. It stores the current state of your deployed resources and is essential for planning and applying changes.

---

### Flashcard 2

**Q:** Why is the state file important in Terraform?  
**A:** It helps Terraform know what resources it manages, detect changes, plan accurate updates, and prevent infrastructure drift.

---

### Flashcard 3

**Q:** What is the purpose of `terraform show`?  
**A:** It displays the current state in a human-readable format for auditing and review.

---

### Flashcard 4

**Q:** What does `terraform state list` do?  
**A:** Lists all resources currently tracked in the Terraform state file.

---

### Flashcard 5

**Q:** How do you view detailed information about a specific resource in the state?  
**A:** Use `terraform state show <resource_address>`.

---

### Flashcard 6

**Q:** What is the difference between `terraform state rm` and `terraform destroy`?  
**A:** `state rm` only removes the resource from Terraform’s tracking; it doesn't delete the actual resource. `destroy` removes the resource from both Terraform and the infrastructure.

---

### Flashcard 7

**Q:** When would you use `terraform import`?  
**A:** To bring an existing resource into Terraform’s management without re-creating it.

---

### Flashcard 8

**Q:** What is `terraform state mv` used for?  
**A:** To move or rename a resource in the state file, often used when refactoring modules.

---

### Flashcard 9

**Q:** What is `terraform refresh`, and is it still recommended?  
**A:** It updates the state file with the real infrastructure state. It's deprecated as of Terraform 1.6+ in favor of `terraform apply`.

---

### Flashcard 10

**Q:** How do you prevent state conflicts in a team environment?  
**A:** Use a remote backend with state locking (e.g., Azure Storage, S3 with DynamoDB).

---

Let me know if you'd like this exported as a `.md` file or we can proceed with **Topic 17: Terraform Provisioners**.