Perfect, ByteBuddy on it! 🚀  
Here’s **✅ Topic 25: Terraform Debugging & Logging**, followed by **Notion-ready Markdown flashcards**.

---

# ✅ **Topic 25: Terraform Debugging & Logging**

## 🐞 Why Debugging Matters in Terraform

Terraform relies on configuration, providers, and state files. When issues arise (e.g., apply failures, state mismatch, provider bugs), **debugging** becomes essential.

Terraform provides several built-in tools to assist with **troubleshooting** and **understanding internal behavior**.

---

## 🔍 Debugging with Environment Variables

Terraform uses the following **environment variables** for debugging:

### 1. `TF_LOG`

- Controls the log verbosity level.
    
- Acceptable values:
    
    - `TRACE` (most verbose)
        
    - `DEBUG`
        
    - `INFO`
        
    - `WARN`
        
    - `ERROR` (least verbose)
        

```bash
export TF_LOG=DEBUG
```

### 2. `TF_LOG_PATH`

- Writes logs to a file instead of stdout.
    

```bash
export TF_LOG_PATH=./terraform-debug.log
```

> Use both together for persistent debug logs.

---

### 🧪 Example Usage

```bash
export TF_LOG=DEBUG
export TF_LOG_PATH=./debug.log
terraform apply
```

> After running, check the log file (`debug.log`) to trace issues.

---

## 🧰 Additional Debugging Tools

|Tool/Command|Purpose|
|---|---|
|`terraform plan`|Preview changes before apply|
|`terraform show`|View details of plan or state|
|`terraform state show`|Inspect specific resource state|
|`terraform console`|Test expressions interactively|
|`terraform validate`|Check for syntax errors|

---

## ⚠️ Best Practices

- Don’t leave `TF_LOG` set permanently — it may expose secrets in logs.
    
- Always **redact logs** before sharing in public forums.
    
- Set log level only as high as needed (`DEBUG` or `INFO` usually suffice).
    

---

## 🔒 Common Debugging Scenarios

|Scenario|Suggestion|
|---|---|
|Apply fails unexpectedly|Use `TF_LOG=DEBUG` and inspect full output|
|Provider not authenticating|Validate credentials and check logs|
|Resource recreated on each apply|Check lifecycle meta-arguments and drift|
|Variable not working as expected|Use `terraform console` to inspect `var.*`|

---

## 🧠 Flashcards: Terraform Debugging & Logging (Markdown - Notion Friendly)

```markdown
# 📚 Terraform Flashcards – Topic 25: Debugging & Logging

## Flashcard 1
**Q:** What environment variable controls Terraform log verbosity?  
**A:** `TF_LOG`

## Flashcard 2
**Q:** What are the valid log levels for `TF_LOG`?  
**A:** TRACE, DEBUG, INFO, WARN, ERROR

## Flashcard 3
**Q:** How do you write debug logs to a file?  
**A:** Set `TF_LOG_PATH` to the file path (e.g., `export TF_LOG_PATH=./debug.log`)

## Flashcard 4
**Q:** What happens if you forget to unset `TF_LOG`?  
**A:** Terraform will keep generating verbose logs, which may expose sensitive data.

## Flashcard 5
**Q:** Which Terraform command previews changes without applying them?  
**A:** `terraform plan`

## Flashcard 6
**Q:** What does `terraform validate` do?  
**A:** Checks configuration for syntax and internal consistency errors.

## Flashcard 7
**Q:** What is a common use of `terraform console` in debugging?  
**A:** Inspecting variable values or testing expressions.

## Flashcard 8
**Q:** If a resource keeps getting recreated, what should you inspect?  
**A:** Lifecycle arguments, external drift, and state differences.

## Flashcard 9
**Q:** Where should you avoid sharing Terraform debug logs directly?  
**A:** Public forums or unsecured channels, as logs may contain sensitive information.

## Flashcard 10
**Q:** What two env variables are used together to debug Terraform into a log file?  
**A:** `TF_LOG` and `TF_LOG_PATH`
```

---

Would you like to proceed with **Topic 26: Terraform Refresh & Replace**, or get a zipped bundle of all topics/flashcards so far?