Let's dive into **Topic 17: Terraform Provisioners** and then generate flashcards in Markdown format.

## 🧠 Terraform Flashcards: Provisioners (Markdown Format)

```markdown
## 📚 Terraform Flashcards: Provisioners (Topic 17)

---

### Flashcard 1  
**Q:** What is a provisioner in Terraform?  
**A:** A way to execute scripts or commands on local or remote machines during the resource lifecycle.

---

### Flashcard 2  
**Q:** What are the two main types of provisioners?  
**A:** `local-exec` and `remote-exec`.

---

### Flashcard 3  
**Q:** When should you use provisioners?  
**A:** Only when a native Terraform or cloud provider feature isn't available.

---

### Flashcard 4  
**Q:** What does the `local-exec` provisioner do?  
**A:** Executes a command locally on the machine running Terraform.

---

### Flashcard 5  
**Q:** What does the `remote-exec` provisioner do?  
**A:** Runs commands on the target resource via SSH or WinRM.

---

### Flashcard 6  
**Q:** How do you run a provisioner only on resource deletion?  
**A:** Use `when = "destroy"` in the provisioner block.

---

### Flashcard 7  
**Q:** What is a common risk when using provisioners?  
**A:** They can introduce failures or side effects that Terraform cannot fully track or recover from.

---

### Flashcard 8  
**Q:** What’s a better alternative to provisioners when bootstrapping VMs?  
**A:** Use cloud-init, VM extensions, or configuration tools like Ansible or Puppet.

---

### Flashcard 9  
**Q:** Can provisioners be used with any resource type?  
**A:** They are typically used with compute resources like VMs, but technically can be used with any resource.

---

### Flashcard 10  
**Q:** Can you chain multiple provisioners?  
**A:** Yes, you can declare multiple provisioner blocks within a resource.

---
```

Would you like this exported as `.md` or shall we move ahead with **Topic 18: Taint and Repair (terraform taint/untaint)**?