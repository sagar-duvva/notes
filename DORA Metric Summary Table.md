Here is a **Notion-ready summary table** for the **DORA Metrics** with performance levels, definitions, and examples — formatted for direct copy-paste into Notion (table block, toggle list, or inline database).

---

## 📌 DORA Metrics – Notion-Ready Summary Table

### 🔷 Table: DORA Metrics Overview

|**Metric**|**Definition**|**Why It Matters**|**Elite**|**Example**|
|---|---|---|---|---|
|**Deployment Frequency**|How often code is deployed to production.|Measures speed and agility of releases.|Multiple times per day|5 daily deployments via CI/CD|
|**Lead Time for Changes**|Time from code commit to production deployment.|Indicates delivery speed and value flow.|Less than 1 day|Code pushed at 9 AM, live in prod at 5 PM|
|**Change Failure Rate**|% of changes that fail in production and require remediation.|Shows stability and code quality.|0% – 15%|2 failures in 20 deployments = 10% CFR|
|**Mean Time to Restore**|Average time to recover from a production failure.|Reflects system reliability and incident recovery speed.|Less than 1 hour|Prod outage at 1 PM, resolved by 1:45 PM|

---

### 🟨 Performance Levels by Metric

|**Performance Level**|**Deployment Frequency**|**Lead Time for Changes**|**Change Failure Rate**|**Mean Time to Restore**|
|---|---|---|---|---|
|**Elite**|Multiple times per day|< 1 day|0% – 15%|< 1 hour|
|**High**|1/day to 1/week|1 day – 1 week|16% – 30%|< 1 day|
|**Medium**|1/week to 1/month|1 week – 1 month|31% – 45%|1 day – 1 week|
|**Low**|< 1/month|> 1 month|> 46%|> 1 week|

---

### ✅ Sample Team Evaluation (Toggle List or Inline Card)

> **Team Alpha – Evaluation Snapshot**
> 
> - **Deployment Frequency**: 10/day ✅ _Elite_
>     
> - **Lead Time for Changes**: 12 hours ✅ _Elite_
>     
> - **Change Failure Rate**: 12% ✅ _Elite_
>     
> - **Mean Time to Restore**: 40 minutes ✅ _Elite_
>     
> - **Summary**: This team operates at **Elite level** on all 4 DORA metrics.
>     

---

Would you like a **downloadable Notion `.md` file**, or should I generate a **Notion import-ready table in CSV** for easier setup in Notion databases?