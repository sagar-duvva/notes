Here's the **Terraform Learning Plan: Topic 23 – Remote Exec Provisioner**, explained in detail with **5 real-world Azure cloud examples** and **Notion-friendly Markdown flashcards**.

---

# 🛰️ Topic 23: Terraform `remote-exec` Provisioner

---

## 🧾 What is `remote-exec`?

Terraform’s `remote-exec` provisioner lets you **execute commands/scripts** **on the remote VM** **after it's created**, using SSH (Linux) or WinRM (Windows).

---

### 📌 Syntax

```hcl
resource "azurerm_linux_virtual_machine" "example" {
  # ... VM config

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
  }

  connection {
    type     = "ssh"
    user     = "azureuser"
    private_key = file("~/.ssh/id_rsa")
    host     = self.public_ip_address
  }
}
```

---

## ⚙️ When to Use `remote-exec`?

|Use Case|Recommended?|
|---|---|
|Simple bootstrapping/config setup|✅ Yes|
|Long-term configuration management|❌ Use Ansible/Chef|
|Installing agents/scripts post-VM|✅ Yes|

---

## ⚠️ Important Notes

- Requires **public IP** or VPN-accessible VM
    
- Ensure **SSH key or WinRM creds** are provided
    
- Avoid long-running or fragile scripts
    
- Not **idempotent** — may re-run on every change
    

---

## ☁️ 5 Real-World Azure Examples

---

### ✅ Example 1: **Install NGINX on Ubuntu VM**

```hcl
provisioner "remote-exec" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install -y nginx"
  ]
}
```

🔹 **Use case:** Quickly bootstrap a web server after provisioning a Linux VM.

---

### ✅ Example 2: **Run PowerShell Script on Windows VM**

```hcl
provisioner "remote-exec" {
  inline = [
    "powershell.exe -Command \"Install-WindowsFeature -Name Web-Server\""
  ]
}

connection {
  type     = "winrm"
  user     = "adminuser"
  password = var.admin_password
  host     = self.public_ip_address
}
```

🔹 **Use case:** Configure IIS after spinning up a Windows VM in Azure.

---

### ✅ Example 3: **Download & Install Monitoring Agent**

```hcl
provisioner "remote-exec" {
  inline = [
    "curl -s https://aka.ms/InstallMonitoringAgent.sh | bash"
  ]
}
```

🔹 **Use case:** Auto-install Azure Monitor Agent or custom monitoring tools.

---

### ✅ Example 4: **Mount and Format Data Disk**

```hcl
provisioner "remote-exec" {
  inline = [
    "sudo mkfs.ext4 /dev/sdc",
    "sudo mkdir /mnt/data",
    "sudo mount /dev/sdc /mnt/data"
  ]
}
```

🔹 **Use case:** Automatically format and mount new data disk attached to the Azure VM.

---

### ✅ Example 5: **Run Custom Shell Script**

```hcl
provisioner "remote-exec" {
  script = "scripts/init_app.sh"
}
```

🔹 **Use case:** Run custom post-deployment application setup stored in a local script file.

---

## 🛡 Best Practices

- Prefer **scripts** over `inline` for readability
    
- Use `local-exec` for running commands **on your machine**
    
- Don’t use for full provisioning — use **Ansible or cloud-init**
    
- Combine with **Key Vault** for secrets injection
    

---

## 🧠 Pro Tip

If you're using Azure DevOps/GitHub Actions, avoid `remote-exec` and prefer custom images or cloud-init scripts for stable provisioning pipelines.

---

## 📚 Flashcards – Topic 23: Remote Exec (Markdown Format for Notion)

```markdown
# 📚 Terraform Flashcards – Topic 23: Remote Exec

## Flashcard 1
**Q:** What is the purpose of Terraform’s `remote-exec` provisioner?  
**A:** It runs shell or PowerShell commands on the VM after creation using SSH or WinRM.

## Flashcard 2
**Q:** Which block is used to connect to the remote VM?  
**A:** The `connection` block (with SSH or WinRM credentials).

## Flashcard 3
**Q:** What are common use cases for `remote-exec` in Azure?  
**A:** Installing software (NGINX, IIS), bootstrapping agents, formatting disks.

## Flashcard 4
**Q:** What’s the risk of using `remote-exec` for major configuration?  
**A:** It's not idempotent and may re-run unnecessarily — better to use Ansible/Puppet.

## Flashcard 5
**Q:** Can `remote-exec` use a local script file?  
**A:** Yes, with `script = "path/to/script.sh"` instead of `inline`.

## Flashcard 6
**Q:** What provisioner would you use to run a command on your own machine instead?  
**A:** `local-exec`.

## Flashcard 7
**Q:** Does `remote-exec` work if VM doesn't have a public IP?  
**A:** No, unless you access via VPN or Bastion — VM must be reachable.

## Flashcard 8
**Q:** Is `remote-exec` secure by default?  
**A:** Not entirely — ensure secure keys/passwords and avoid exposing secrets.

## Flashcard 9
**Q:** How can you avoid repeating provisioning logic every time?  
**A:** Use cloud-init or custom VM images instead of provisioners.

## Flashcard 10
**Q:** Can you combine `remote-exec` with Azure Key Vault secrets?  
**A:** Yes, by injecting secrets into variables and using them inside scripts.
```

---

Would you like this added to the downloadable ZIP of all topics or exported to Notion directly?