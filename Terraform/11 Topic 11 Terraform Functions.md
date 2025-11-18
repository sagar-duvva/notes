Great! Let’s dive into **Topic 11: Terraform Functions** – one of the most powerful features in Terraform used to transform and manipulate values.

---

## ✅ Overview: Terraform Functions

Terraform provides a large set of **built-in functions** that fall into several categories:

|Category|Description|
|---|---|
|String Functions|Manipulate and transform strings|
|Numeric Functions|Perform arithmetic and number-based operations|
|Collection Functions|Work with lists, maps, sets|
|Date/Time Functions|Work with timestamps and durations|
|Encoding Functions|Convert data formats like base64, CSV, JSON|
|File Functions|Read local files and templates|
|Hash/Encryption|Generate hashes and encryption-based outputs|
|IP Network Functions|Handle CIDR blocks and IP calculations|
|Type Conversion|Convert between types like string → number|
|Misc Functions|e.g., `uuid()`, `nonsensitive()`|

---

### 🔍 Let’s cover the **most useful functions** with categorized examples:

---

### 🧩 **1. String Functions**

|Function|Purpose|Example|
|---|---|---|
|`join()`|Join list into string|`join("-", ["vm", "prod", "01"])` → `"vm-prod-01"`|
|`replace()`|Replace part of string|`replace("vm-prod", "prod", "dev")` → `"vm-dev"`|
|`lower()` / `upper()`|Convert case|`lower("DEVOPS")` → `"devops"`|

---

### 🧮 **2. Numeric Functions**

|Function|Purpose|Example|
|---|---|---|
|`max()` / `min()`|Get maximum or minimum|`max(3, 9, 2)` → `9`|
|`abs()`|Absolute value|`abs(-4)` → `4`|

---

### 📦 **3. Collection Functions (list, map, set)**

|Function|Purpose|Example|
|---|---|---|
|`length()`|Count items in a list/map|`length(["a", "b"])` → `2`|
|`lookup()`|Get value from map with default|`lookup(var.config, "env", "dev")`|
|`contains()`|Check if list has item|`contains(["a", "b"], "b")` → `true`|
|`merge()`|Merge maps|`merge(map1, map2)`|
|`zipmap()`|Create map from 2 lists|`zipmap(["a", "b"], [1, 2])` → `{ a = 1, b = 2 }`|

---

### 🕒 **4. Date/Time Functions**

|Function|Purpose|Example|
|---|---|---|
|`timestamp()`|Current UTC timestamp|`"2025-08-04T09:10:00Z"`|
|`timeadd()`|Add duration to timestamp|`timeadd(timestamp(), "1h")`|

---

### 🔐 **5. Hash & Encryption Functions**

|Function|Purpose|Example|
|---|---|---|
|`md5()`, `sha1()`|Generate hash|`md5("admin")` → `21232f297a57a5a743894a0e4a801fc3`|
|`bcrypt()`|Secure password hashing|Secure passwords for modules|

---

### 🛠️ **6. Type Conversion & Misc**

|Function|Purpose|Example|
|---|---|---|
|`tostring()`|Convert any value to string|`tostring(100)` → `"100"`|
|`tonumber()`|Convert to number|`tonumber("42")` → `42`|
|`uuid()`|Generate unique ID|`"d5063d94-f4b7-11ec-8ea0-0242ac120002"`|

---

### 🔐 7. **Secrets and Safe Output**

|Function|Purpose|
|---|---|
|`sensitive()`|Mark value as sensitive|
|`nonsensitive()`|View sensitive value (with caution)|

---

### 🧠 Tip: Functions can be nested

```hcl
locals {
  name = lower(join("-", ["App", "DEV"]))
}
```

---

Would you like me to now generate:

- ✅ Flashcards (Markdown format)
    
- 📁 Downloadable `.tf` examples using various function types
    
- 🎯 Move to Topic 12: Meta-Arguments
    

Let me know what you'd prefer next!