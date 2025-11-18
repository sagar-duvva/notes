
## 🧠 Flashcards: Terraform Modules (Markdown, Notion-Ready)

````markdown
# Terraform Modules Flashcards

## Q1: What is a Terraform module?
A reusable block of Terraform configuration that can include resources, input/output variables, etc.

## Q2: What are the types of modules in Terraform?
- Root Module
- Child Module
- Public Module (from Registry)

## Q3: Why use Terraform modules?
To ensure consistency, reusability, scalability, and maintainability in infrastructure deployments.

## Q4: How do you call a module?
```hcl
module "example" {
  source = "../modules/example"
  var1   = "value"
}
````

## Q5: What files should every module have?

- `main.tf`
    
- `variables.tf`
    
- `outputs.tf`
    
- Optionally `README.md`
    

## Q6: How do modules handle inputs and outputs?

Inputs are defined using `variable`, and outputs with `output` blocks, which are returned to the calling module.

## Q7: Can modules be nested?

Yes, modules can call other modules.

## Q8: What’s the difference between a local and remote module?

Local modules are in your repo (`../modules/xyz`). Remote modules come from Git or Terraform Registry.

## Q9: How can modules help in multi-environment setup?

You can call the same module in multiple environments like `prod`, `staging`, passing different variables.

## Q10: How do you pass variables to a module?

Using key-value pairs inside the module block in your root module.

```

---

Would you like a downloadable version of these flashcards or should we move on to **Topic 13: Backends**?
```