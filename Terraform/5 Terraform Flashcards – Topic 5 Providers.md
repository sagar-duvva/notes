Great! Here's the **Notion-friendly Markdown version** of the **Terraform Topic 5: Providers Flashcards**. You can paste this directly into Notion as a database, toggle list, or page with collapsible headings.

---

# 📦 Terraform Flashcards – Topic 5: Providers

---

A provider is a plugin that allows Terraform to interact with external APIs such as Azure, AWS, GCP, GitHub, and more.  
It's how Terraform knows _what_ kind of infrastructure to manage and _how_ to talk to it.

---

```hcl
provider "azurerm" {
  features {}
}
```

You must also specify the provider version using `required_providers` inside a `terraform` block.

---

```hcl
provider "aws" {
  region  = "us-west-1"
  profile = "default"
}
```

The `profile` uses AWS credentials from `~/.aws/credentials`.

---

Aliases allow multiple configurations of the same provider type (e.g., two different Azure regions).

```hcl
provider "azurerm" {
  alias   = "central"
  features {}
  location = "Central India"
}
```

---

Use the `provider` attribute to assign the alias:

```hcl
resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "Central India"
  provider = azurerm.central
}
```

---

To ensure consistent behavior across environments and avoid unexpected breaking changes from new releases.

```hcl
required_providers {
  azurerm = {
    source  = "hashicorp/azurerm"
    version = "~> 3.0"
  }
}
```

---

- Pin provider versions
    
- Avoid hardcoding secrets in `.tf` files
    
- Use aliases for multi-region or multi-account deployments
    
- Use environment variables for credentials
    
- Use `terraform providers lock` for version lock-ins
    

---

Would you like me to generate a ZIP of provider examples before moving on to **Topic 6: Resources**? Or shall we continue right away?