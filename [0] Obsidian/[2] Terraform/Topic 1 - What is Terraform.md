##  **Topic 1: What is Terraform?**

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
