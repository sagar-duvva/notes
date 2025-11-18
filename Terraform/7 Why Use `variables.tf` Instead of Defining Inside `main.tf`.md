
## ❓ Query 3: Why Use `variables.tf` Instead of Defining Inside `main.tf`?

|Aspect|`main.tf` Only|`variables.tf` Separation|
|---|---|---|
|🔸 Organization|Mixed resource and variable logic|Clear structure: logic split across files|
|🔸 Maintainability|Hard to navigate in large projects|Easier to maintain, especially in teams|
|🔸 Reusability|Reduces across-module duplication|Variables can be reused in multiple files/modules|
|🔸 Collaboration|Less friendly for collaboration|Teams can edit inputs (`variables.tf`) without touching infrastructure logic|

📌 It’s valid to define them in `main.tf`, but separating into `variables.tf` is a **best practice** for medium to large-scale infrastructure.
