Great! Let's continue 🚀

---

# ✅ **Topic 23: Terraform Import**

Followed by **Notion-friendly flashcards** in Markdown format at the end.

---

## 🧲 What Is `terraform import`?

The `terraform import` command **brings existing infrastructure** into Terraform's state management **without modifying the resource**.

> 🔄 It allows Terraform to manage resources that were **created manually or by another tool**.

---

## 🛠️ Syntax

```bash
terraform import [options] <resource_address> <resource_id>
```

---

## 📌 Example: Import an AWS EC2 Instance

### Terraform Code (`main.tf`)

```hcl
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
}
```

### Command to Import:

```bash
terraform import aws_instance.example i-0abcd1234efgh5678
```

> After importing, run `terraform plan` to see any differences between the actual resource and the configuration.

---

## ⚠️ Important Notes

- **Terraform does not generate the configuration** — you must write it manually before importing.
    
- Importing only links the existing infrastructure to the state file.
    
- If config does not match actual settings, Terraform will try to change the resource on `apply`.
    

---

## 📂 Common Use Cases

|Use Case|Example|
|---|---|
|Adopt manually created resources|Import AWS S3 bucket not created by Terraform|
|Move from another IaC tool|Transition from CloudFormation, ARM, etc.|
|Onboard legacy infrastructure|Start managing old production resources with Terraform|

---

## 📁 Import Resource IDs (By Provider)

|Provider|Example Resource|Resource ID Format|
|---|---|---|
|AWS|EC2 Instance|`i-xxxxxxxxxxxxxxxxx`|
|Azure|Storage Account|Resource ID (full ARM path)|
|Google Cloud|Compute Instance|`project/zone/instance-name`|
|Kubernetes|Pod|`default/pod-name`|

---

## 💡 Tips

- Use `terraform state show` after import to verify success.
    
- Use `terraform plan` to confirm that Terraform won’t overwrite your resource.
    
- Back up your infrastructure before importing.
    

---

## 🧠 Flashcards: Terraform Import (Markdown - Notion Friendly)

```markdown
# 📚 Terraform Flashcards – Topic 23: terraform import

## Flashcard 1
**Q:** What does `terraform import` do?  
**A:** It allows Terraform to start managing existing infrastructure by importing it into the state.

## Flashcard 2
**Q:** Can `terraform import` generate Terraform configuration?  
**A:** No, you must manually write the resource block before importing.

## Flashcard 3
**Q:** What is the basic syntax of the import command?  
**A:** `terraform import <resource_address> <resource_id>`

## Flashcard 4
**Q:** What should you do after importing a resource?  
**A:** Run `terraform plan` to review any differences between configuration and infrastructure.

## Flashcard 5
**Q:** What happens if the configuration doesn't match the actual imported resource?  
**A:** Terraform will attempt to update the resource to match the config during the next `terraform apply`.

## Flashcard 6
**Q:** What command imports an EC2 instance with ID `i-1234567890abcdef0` to `aws_instance.example`?  
**A:** `terraform import aws_instance.example i-1234567890abcdef0`

## Flashcard 7
**Q:** Does `terraform import` make any changes to the actual infrastructure?  
**A:** No, it only updates the Terraform state.

## Flashcard 8
**Q:** Where can you find the correct resource ID for importing Azure resources?  
**A:** In the Azure Portal or using `az resource show` for the full ARM ID.

## Flashcard 9
**Q:** What's a common use case for using `terraform import`?  
**A:** Bringing manually created resources under Terraform management.

## Flashcard 10
**Q:** Which command helps verify the imported resource's attributes?  
**A:** `terraform state show <resource_address>`
```

---

Would you like to continue with **Topic 24: Terraform Console**, or should I export all flashcards so far into a `.md` file or ZIP package?