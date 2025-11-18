Hey Sagar! Here's a **Terraform Commands Cheat Sheet** in a table format for a quick glance before your interview:

---

### ✅ Terraform Commands Cheat Sheet

|**Command**|**Short Description**|
|---|---|
|`terraform init`|Initialize a Terraform working directory.|
|`terraform plan`|Show changes that will be applied.|
|`terraform apply`|Apply the changes required to reach the desired state.|
|`terraform destroy`|Destroy the Terraform-managed infrastructure.|
|`terraform validate`|Validate the configuration files.|
|`terraform fmt`|Format configuration files to canonical style.|
|`terraform show`|Show the current state or plan details.|
|`terraform output`|Extract output variables from the state file.|
|`terraform state`|Advanced state management (list, show, remove, etc.).|
|`terraform providers`|List providers used in the configuration.|
|`terraform version`|Display Terraform version.|
|`terraform graph`|Generate a visual graph of the dependency structure.|
|`terraform login`|Authenticate to Terraform Cloud or Enterprise.|
|`terraform logout`|Remove credentials for Terraform Cloud/Enterprise.|
|`terraform import`|Import existing infrastructure into Terraform.|
|`terraform taint`|Mark a resource for recreation in the next apply.|
|`terraform untaint`|Remove taint from a resource.|
|`terraform refresh`|Sync the state with real-world resources.|
|`terraform workspace`|Manage multiple workspaces.|
|`terraform state list`|List resources in the state file.|
|`terraform state show`|Show attributes of a specific resource in the state.|

---

Now let’s break down **each command with 3 real-world examples**:

---

## 🔹 1. `terraform init`

Initializes the working directory and downloads provider plugins.

### Examples:

```bash
terraform init
```

- Initializes the current directory.
    

```bash
terraform init -backend-config="backend.tfvars"
```

- Initializes with custom backend settings.
    

```bash
terraform init -upgrade
```

- Upgrades modules and plugins to newer versions.
    

---

## 🔹 2. `terraform plan`

Shows what actions Terraform will take without applying changes.

### Examples:

```bash
terraform plan
```

- Basic plan for current code.
    

```bash
terraform plan -out=tfplan
```

- Save plan to a file.
    

```bash
terraform plan -var="env=dev"
```

- Override a variable on the fly.
    

---

## 🔹 3. `terraform apply`

Applies the desired state to the infrastructure.

### Examples:

```bash
terraform apply
```

- Applies changes with confirmation.
    

```bash
terraform apply tfplan
```

- Applies a previously saved plan.
    

```bash
terraform apply -auto-approve
```

- Applies changes without confirmation.
    

---

## 🔹 4. `terraform destroy`

Destroys all resources managed by Terraform.

### Examples:

```bash
terraform destroy
```

- Prompt to confirm destruction.
    

```bash
terraform destroy -auto-approve
```

- Destroys without confirmation.
    

```bash
terraform destroy -target=azurerm_resource_group.rg
```

- Destroys a specific resource.
    

---

## 🔹 5. `terraform validate`

Validates the syntax and internal consistency of Terraform code.

### Examples:

```bash
terraform validate
```

- Validate current directory.
    

```bash
terraform validate -no-color
```

- Clean output for CI/CD logs.
    

```bash
terraform validate some_directory/
```

- Validate code in a different folder.
    

---

## 🔹 6. `terraform fmt`

Automatically formats Terraform code.

### Examples:

```bash
terraform fmt
```

- Format current directory.
    

```bash
terraform fmt -recursive
```

- Format all subdirectories.
    

```bash
terraform fmt -check
```

- Check formatting without applying changes.
    

---

## 🔹 7. `terraform show`

Displays the contents of the Terraform state or plan.

### Examples:

```bash
terraform show
```

- Show current state.
    

```bash
terraform show tfplan
```

- Show saved plan file.
    

```bash
terraform show -json
```

- Output in JSON format.
    

---

## 🔹 8. `terraform output`

Display output values from the last apply.

### Examples:

```bash
terraform output
```

- Show all outputs.
    

```bash
terraform output public_ip
```

- Show a specific output value.
    

```bash
terraform output -json
```

- JSON formatted output for scripting.
    

---

## 🔹 9. `terraform state`

Advanced command for state management.

### Examples:

```bash
terraform state list
```

- Lists all resources.
    

```bash
terraform state show azurerm_resource_group.rg
```

- Shows details of a specific resource.
    

```bash
terraform state rm azurerm_virtual_machine.vm
```

- Removes a resource from the state.
    

---

## 🔹 10. `terraform providers`

Lists all providers used in the current configuration.

### Examples:

```bash
terraform providers
```

- Basic listing.
    

```bash
terraform providers mirror ./localdir
```

- Mirror plugins locally.
    

```bash
terraform providers lock -platform=linux_amd64
```

- Lock provider versions for specific platform.
    

---

## 🔹 11. `terraform version`

Shows installed Terraform version.

### Examples:

```bash
terraform version
```

- Shows version and providers.
    

```bash
terraform version -json
```

- JSON formatted output.
    

```bash
terraform version | grep Terraform
```

- For scripts.
    

---

## 🔹 12. `terraform graph`

Generates a dependency graph.

### Examples:

```bash
terraform graph
```

- Outputs DOT format.
    

```bash
terraform graph | dot -Tpng > graph.png
```

- Visualize with Graphviz.
    

```bash
terraform graph -draw-cycles
```

- Highlight cyclical dependencies.
    

---

## 🔹 13. `terraform login`

Authenticates to Terraform Cloud or Enterprise.

### Examples:

```bash
terraform login
```

- Opens browser login.
    

```bash
terraform login --token=xxxx
```

- Use token manually.
    

```bash
terraform login -hostname app.terraform.io
```

- Login to specific host.
    

---

## 🔹 14. `terraform logout`

Removes stored credentials.

### Examples:

```bash
terraform logout
```

- Logs out of default host.
    

```bash
terraform logout -hostname app.terraform.io
```

- Logs out from specific host.
    

---

## 🔹 15. `terraform import`

Brings existing infrastructure into Terraform state.

### Examples:

```bash
terraform import azurerm_resource_group.rg my-rg
```

- Imports an Azure resource group.
    

```bash
terraform import aws_instance.web i-0e123456789
```

- Imports AWS EC2 instance.
    

```bash
terraform import module.db.azurerm_sql_server.sql sqlserverid
```

- Imports resource in a module.
    

---

## 🔹 16. `terraform taint`

Marks resource for recreation on next apply.

### Examples:

```bash
terraform taint azurerm_virtual_machine.vm
```

- Forces VM to be recreated.
    

```bash
terraform taint module.app.azurerm_app_service.service
```

- Inside module.
    

```bash
terraform taint -allow-missing azurerm_lb.lb
```

- Taint non-existing resource safely.
    

---

## 🔹 17. `terraform untaint`

Removes taint.

### Examples:

```bash
terraform untaint azurerm_virtual_machine.vm
```

- Remove taint from VM.
    

```bash
terraform untaint module.db.azurerm_sql_database.db
```

- Inside module.
    

```bash
terraform untaint -allow-missing azurerm_public_ip.ip
```

- Silent untaint.
    

---

## 🔹 18. `terraform refresh`

Updates state file from actual resources.

### Examples:

```bash
terraform refresh
```

- Update state.
    

```bash
terraform refresh -target=azurerm_storage_account.storage
```

- Refresh only specific resource.
    

```bash
terraform refresh -lock=false
```

- Skip state locking.
    

---

## 🔹 19. `terraform workspace`

Manage multiple environments.

### Examples:

```bash
terraform workspace new dev
```

- Create new workspace.
    

```bash
terraform workspace select prod
```

- Switch to `prod` workspace.
    

```bash
terraform workspace list
```

- List all workspaces.
    

---

If you'd like this in a **printable PDF**, Notion, or Excel format — let me know and I’ll generate it for you!

Would you like a visual flashcard version next?