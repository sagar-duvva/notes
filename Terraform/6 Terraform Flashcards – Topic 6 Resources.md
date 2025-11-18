Here you go! Below is the **Notion-friendly Markdown version** of the **Terraform Topic 6: Resources Flashcards**. You can copy-paste this into Notion as a toggle list or use it for printable cards later.

---

# 📦 Terraform Flashcards – Topic 6: Resources

---

A resource represents a piece of infrastructure Terraform manages.  
It can be a VM, storage account, network, GitHub repo, etc.

---

```hcl
resource "<PROVIDER>_<TYPE>" "<NAME>" {
  # arguments
}
```

Example:

```hcl
resource "azurerm_resource_group" "main" {
  name     = "example-rg"
  location = "East US"
}
```

---

```hcl
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name"
  acl    = "private"
}
```

---

```hcl
resource "docker_container" "nginx" {
  name  = "nginx"
  image = docker_image.nginx.latest
  ports {
    internal = 80
    external = 8080
  }
}
```

---

Creates multiple copies of a resource:

```hcl
resource "azurerm_storage_account" "example" {
  count = 2
  name  = "storage${count.index}"
}
```

---

Allows iteration over a map or set:

```hcl
resource "azurerm_subnet" "example" {
  for_each = var.subnets
  name     = each.key
  address_prefix = each.value
}
```

---

Explicitly declares dependencies between resources.

```hcl
depends_on = [azurerm_resource_group.main]
```

---

Used to manage Terraform’s behavior during create/update/delete.

```hcl
lifecycle {
  prevent_destroy = true
}
```

---

- Use descriptive names
    
- Avoid hardcoding
    
- Use `count` or `for_each` for scaling
    
- Add `depends_on` if needed
    
- Use `lifecycle` to protect critical resources
    

---

Would you like me to generate a **working resource examples ZIP** or proceed to **Topic 7: Variables**?