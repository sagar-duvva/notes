Let's dive into **Topic 17: Terraform Provisioners** and then generate flashcards in Markdown format.

---

## 📘 Topic 17: Terraform Provisioners

### 🔹 What Are Provisioners?

Provisioners in Terraform allow you to run scripts or commands **on a local machine or on a remote resource** after it's created. They're commonly used to bootstrap instances (e.g., install software, configure files).

There are **two types** of provisioners:

- **`local-exec`**: Runs a command on the machine running Terraform.
    
- **`remote-exec`**: Runs a command on the provisioned resource via SSH or WinRM.
    

> ⚠️ **Best Practice:** Use provisioners only when there's no other native way to accomplish a task in Terraform (e.g., cloud-init, automation tools like Ansible or scripts through VM extensions).

---

### ✅ Syntax Example

```hcl
resource "azurerm_virtual_machine" "example" {
  # VM config...

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]

    connection {
      type     = "ssh"
      user     = "azureuser"
      private_key = file("~/.ssh/id_rsa")
      host     = self.public_ip_address
    }
  }
}
```

---

## 🔄 Lifecycle Meta-Arguments

You can use provisioners **with `create` and `destroy`** time execution using:

```hcl
provisioner "local-exec" {
  when    = "destroy"
  command = "echo Destroying VM!"
}
```

---

## 🔧 Common Use Cases

- Install packages or agents (e.g., Nginx, Azure Monitoring Agent)
    
- Register a VM to a configuration management system
    
- Run cleanup scripts during destroy
    
- Push bootstrap scripts to instances
    

---

## 🚫 Cautions

- Provisioners can fail or hang and might leave infrastructure in an inconsistent state.
    
- Terraform cannot fully track what was done via provisioners.
    
- Avoid provisioners for critical infra tasks. Use native providers or configuration management.
    



Absolutely! Here are **5 real-world complex examples** of using **Terraform provisioners**, demonstrating both `local-exec` and `remote-exec` usage, with SSH keys, dynamic variables, and lifecycle conditions.

---

## ✅ Example 1: Installing NGINX on Azure Linux VM via `remote-exec`

```hcl
resource "azurerm_linux_virtual_machine" "web" {
  name                = "nginx-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20_04-lts"
    version   = "latest"
  }

  disable_password_authentication = true
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx"
    ]

    connection {
      type        = "ssh"
      user        = "azureuser"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip_address
    }
  }
}
```

---

## ✅ Example 2: `local-exec` to Trigger Ansible Playbook Post Deployment

```hcl
resource "null_resource" "run_ansible" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${azurerm_linux_virtual_machine.vm.public_ip_address},' site.yml"
  }

  depends_on = [azurerm_linux_virtual_machine.vm]
}
```

> Use Case: Integrates Ansible to configure VM after it's provisioned via Terraform.

---

## ✅ Example 3: Upload Configuration File to Azure VM and Apply It

```hcl
resource "null_resource" "push_config" {
  connection {
    type        = "ssh"
    user        = "azureuser"
    private_key = file("~/.ssh/id_rsa")
    host        = azurerm_linux_virtual_machine.vm.public_ip_address
  }

  provisioner "file" {
    source      = "config/nginx.conf"
    destination = "/tmp/nginx.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/nginx.conf /etc/nginx/nginx.conf",
      "sudo systemctl restart nginx"
    ]
  }

  depends_on = [azurerm_linux_virtual_machine.vm]
}
```

> Use Case: Automates pushing and applying configurations after deployment.

---

## ✅ Example 4: Destroy-Time Cleanup Script with `local-exec`

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "cleanup-rg"
  location = "eastus"

  provisioner "local-exec" {
    when    = "destroy"
    command = "echo Cleaning up resources in ${self.name}"
  }
}
```

> Use Case: Notifies or logs actions at resource teardown.

---

## ✅ Example 5: Run Python Script via `local-exec` After Infra Creation

```hcl
resource "null_resource" "notify_devops" {
  provisioner "local-exec" {
    command = "python3 scripts/send_notification.py --env=prod --resource=${azurerm_linux_virtual_machine.vm.name}"
  }

  depends_on = [azurerm_linux_virtual_machine.vm]
}
```

> Use Case: Custom post-provisioning logic like sending Slack/email notifications, updating CMDB, etc.

---

## 🗂 Want These as a Downloadable `.zip` with Working .tf Files?

I can generate a ready-to-use ZIP file for all these 5 provisioner examples in proper Terraform structure. Want me to create and share that now?