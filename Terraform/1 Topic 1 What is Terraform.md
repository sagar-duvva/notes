Perfect, Sagar! Let’s kick off your **Terraform journey** with **Topic 1: What is Terraform?**  
At the end, I’ll generate flashcards to help you revise quickly.

---

## 🌱 **Topic 1: What is Terraform?**

### 🧠 **Definition**

Terraform is an open-source **Infrastructure as Code (IaC)** tool developed by HashiCorp. It allows you to define, provision, and manage cloud and on-prem infrastructure in a **declarative configuration language (HCL)**.

---

### 🧩 **Why Terraform?**

- Platform-agnostic: Works with AWS, Azure, GCP, Kubernetes, etc.
    
- Declarative: You describe _what_ you want, not _how_ to get it.
    
- Version-controlled: Infrastructure changes can be tracked via Git.
    
- Automated: Prevents manual errors by codifying infrastructure.
    
- Scalable: Modular and reusable for complex systems.
    

---

### ⚙️ **Key Concepts**

|Concept|Description|
|---|---|
|**Provider**|Plugin that interacts with APIs (e.g., Azure, AWS).|
|**Resource**|Infrastructure component (VM, VNet, S3 bucket).|
|**Module**|Reusable block of Terraform code.|
|**State File**|Stores the current state of infrastructure.|
|**Plan**|Shows changes before applying them.|

---

## ✅ Real-World Examples

### 🔸 Example 1: Deploy a VM in Azure

Use Terraform to define and deploy an Ubuntu VM in Azure using HCL code.

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "example-rg"
  location = "East US"
}
```

---

### 🔸 Example 2: Provision S3 bucket in AWS

Use Terraform to create an S3 bucket with versioning enabled.

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "my-unique-bucket-12345"
  versioning {
    enabled = true
  }
}
```

---

### 🔸 Example 3: Deploy Google Cloud Storage bucket

Define a simple GCS bucket using the GCP provider.

```hcl
provider "google" {
  project = "my-gcp-project"
  region  = "us-central1"
}

resource "google_storage_bucket" "bucket" {
  name     = "my-storage-bucket"
  location = "US"
}
```

---

## 🧠 Flashcards: What is Terraform?

Here’s a PDF flashcard set for this topic to revise later — generating it now...

Here’s your PDF set of flashcards for **"Topic 1: What is Terraform?"**

📄 [Download Terraform_Topic1_What_is_Terraform_Flashcards.pdf](sandbox:/mnt/data/Terraform_Topic1_What_is_Terraform_Flashcards.pdf)

---

Ready for **Topic 2: Terraform Setup**?  
Let me know and I’ll guide you through installation, file structure, and provider authentication with 3 examples + flashcards.