Here’s **Topic 27: Testing Terraform Code** (using `Terratest` and `kitchen-terraform`) fully elaborated, including **5 real-world Azure Cloud examples**, followed by **Notion-friendly flashcards** in **Markdown format**.

---

## 🌟 Topic 27: Testing Terraform Code (Terratest & Kitchen-Terraform)

Infrastructure as Code (IaC) is just like software — **it should be tested** before reaching production. Terraform testing ensures changes do what they're supposed to do, prevent regression, and keep environments stable.

---

### 🧪 Why Test Terraform Code?

- Validate resource creation, updates, and destruction
    
- Detect unexpected behavior before deployment
    
- Ensure repeatability and idempotency
    
- Enable CI/CD pipeline integration
    

---

### ✅ Popular Testing Tools

|Tool|Language|Best For|
|---|---|---|
|**Terratest**|Go|Unit + Integration tests|
|**Kitchen-Terraform**|Ruby|Configuration & Compliance tests|

---

## 🔧 Terratest Overview

Terratest is a **Go-based testing library** that allows writing tests like:

```go
terraformOptions := &terraform.Options{
  TerraformDir: "../example",
}

terraform.InitAndApply(t, terraformOptions)

output := terraform.Output(t, terraformOptions, "resource_name")
assert.Equal(t, "expected-value", output)
```

---

## 🍳 Kitchen-Terraform Overview

Kitchen-Terraform uses **Test Kitchen + InSpec** to:

- Apply Terraform code
    
- Run compliance and state tests
    

Example `.kitchen.yml`:

```yaml
driver:
  name: terraform
provisioner:
  name: terraform
verifier:
  name: inspec
platforms:
  - name: local
suites:
  - name: example
    verifier:
      inspec_tests:
        - test/integration/default
```

---

## 🔍 5 Real-World Azure Examples

---

### **Example 1: Terratest for Azure Resource Group Creation**

Test that a resource group exists after `terraform apply`.

```go
resourceGroup := terraform.Output(t, terraformOptions, "resource_group_name")
exists := azure.ResourceGroupExists(t, resourceGroup, "subscription-id")
assert.True(t, exists)
```

---

### **Example 2: Test VNet CIDR Block Consistency**

Use Terratest to validate the VNet CIDR matches expected:

```go
vnetCIDR := terraform.Output(t, terraformOptions, "vnet_address_space")
assert.Equal(t, "10.0.0.0/16", vnetCIDR)
```

---

### **Example 3: Kitchen-Terraform to Enforce Tags**

Write InSpec tests to validate required Azure tags:

```ruby
describe azure_generic_resource(group_name: 'rg-test', name: 'vm01') do
  its('tags') { should include('environment' => 'dev') }
end
```

---

### **Example 4: Kitchen-Terraform for Security Rules**

Ensure NSG rules don’t allow open RDP (port 3389):

```ruby
describe azure_network_security_group(group_name: 'rg', name: 'nsg') do
  its('security_rules') { should_not include { direction == 'Inbound' && destination_port_range == '3389' } }
end
```

---

### **Example 5: CI/CD Testing with GitHub Actions + Terratest**

Create a workflow to:

- Run Terratest
    
- Deploy only if tests pass
    

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install Go
        uses: actions/setup-go@v3
        with:
          go-version: 1.21
      - run: go test -v ./test/
```

---

## 🧠 Flashcards – Topic 27: Testing Terraform Code

```markdown
# 📘 Terraform Flashcards – Topic 27: Testing Terraform Code

## Flashcard 1
**Q:** What is the purpose of testing Terraform code?
**A:** To validate expected infrastructure behavior, ensure consistency, and catch regressions before deployment.

## Flashcard 2
**Q:** What is Terratest and what language does it use?
**A:** Terratest is a Go-based testing framework for Terraform code that supports unit and integration testing.

## Flashcard 3
**Q:** What is Kitchen-Terraform primarily used for?
**A:** Running configuration and compliance tests using Test Kitchen + InSpec for Terraform projects.

## Flashcard 4
**Q:** How can you use Terratest to validate an Azure resource exists?
**A:** Use `azure.ResourceGroupExists` or similar functions with `terraform.Output`.

## Flashcard 5
**Q:** How can you test if a VNet uses the correct CIDR block in Terratest?
**A:** Compare the output of `terraform.Output()` with the expected CIDR using `assert.Equal()`.

## Flashcard 6
**Q:** What kind of compliance rules can Kitchen-Terraform enforce?
**A:** Tag policies, open port restrictions, encryption settings, and more using InSpec profiles.

## Flashcard 7
**Q:** Can Terratest be integrated with CI/CD tools like GitHub Actions?
**A:** Yes, you can run Go tests in workflows to ensure infrastructure changes pass automated checks before deployment.

## Flashcard 8
**Q:** What does Kitchen-Terraform’s `.kitchen.yml` file configure?
**A:** It defines the Terraform driver, provisioner, verifier, platforms, and test suites.
```

---

Would you like this exported in a ZIP with other flashcards, or want the testing examples scaffolded into a GitHub-ready test suite?