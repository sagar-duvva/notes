

* [ ] Azure Fundamentals
   - [ ] Cloud concepts
    - [ ] IaaS vs PaaS vs SaaS
    - [ ] Regions and Availability Zones
    - [ ] Resource groups and resources
    - [ ] Pricing and SLAs
   - [ ] Core services overview
    - [ ] Compute overview
    - [ ] Storage overview
    - [ ] Networking overview
    - [ ] Databases overview
   - [ ] Getting started
    - [ ] Azure portal
    - [ ] Azure CLI
    - [ ] Azure PowerShell
    - [ ] Cloud Shell

* [ ] Identity & Security (Entra ID / AAD)
   - [ ] Entra ID fundamentals
    - [ ] Tenants and directories
    - [ ] Users and groups
    - [ ] Service principals and managed identities
    - [ ] External identities / B2B / B2C
   - [ ] Authentication & access
    - [ ] Password policies and self-service password reset
    - [ ] Multi-Factor Authentication (MFA)
    - [ ] Conditional Access policies
    - [ ] Identity Protection
   - [ ] Authorization & governance
    - [ ] Role-Based Access Control (RBAC)
    - [ ] Built-in vs custom roles
    - [ ] Privileged Identity Management (PIM)
    - [ ] Consent and application permissions
   - [ ] Certificate & key management
    - [ ] Azure Key Vault
     - [ ] Secrets management
     - [ ] Keys and HSM-backed keys
     - [ ] Certificates
     - [ ] Access policies and RBAC integration
    - [ ] Managed HSM
   - [ ] Security operations
    - [ ] Microsoft Defender for Cloud
    - [ ] Microsoft Sentinel (SIEM)
    - [ ] Secure Score
    - [ ] Identity Governance (Entitlement management)

* [ ] Governance & Compliance
   - [ ] Management structure
    - [ ] Subscriptions design
    - [ ] Management Groups
    - [ ] Landing zones & subscription limits
   - [ ] Policies & controls
    - [ ] Azure Policy
     - [ ] Policy definitions
     - [ ] Initiatives (policy sets)
     - [ ] Remediation tasks
     - [ ] Effects (Audit, Deny, Append, DeployIfNotExists)
    - [ ] Resource locks
    - [ ] Tags and naming conventions
   - [ ] Blueprints & CAF
    - [ ] Azure Blueprints
    - [ ] Cloud Adoption Framework (CAF)
    - [ ] Governance baseline and guardrails
   - [ ] Compliance & auditing
    - [ ] Azure Advisor recommendations
    - [ ] Audit logs & activity logs
    - [ ] Regulatory compliance offerings

* [ ] Networking
   - [ ] Virtual Networking
    - [ ] Virtual Networks (VNets)
    - [ ] Subnets and IP addressing
    - [ ] Network Security Groups (NSGs)
    - [ ] User-Defined Routes (UDR)
    - [ ] VNet peering (regional & global)
    - [ ] Virtual Network NAT
   - [ ] Connectivity
    - [ ] VPN Gateway (site-to-site, point-to-site)
    - [ ] ExpressRoute (private peering, Microsoft peering)
    - [ ] Azure Virtual WAN
    - [ ] Azure Bastion
    - [ ] Virtual Network Gateways
   - [ ] Load balancing & traffic distribution
    - [ ] Azure Load Balancer (basic/standard)
    - [ ] Azure Application Gateway (incl. WAF)
    - [ ] Azure Front Door (global HTTP(s) load balancing)
    - [ ] Traffic Manager
    - [ ] Azure CDN
   - [ ] Private connectivity & endpoint options
    - [ ] Azure Private Link
    - [ ] Service Endpoints
    - [ ] Private Endpoint DNS integration
   - [ ] Security & protection
    - [ ] Azure Firewall
    - [ ] Web Application Firewall (WAF)
    - [ ] DDoS Protection Standard
    - [ ] Network virtual appliances (NVA)
   - [ ] Networking advanced topics
    - [ ] Azure CNI vs Kubenet
    - [ ] Network performance and throughput tuning
    - [ ] TCP/UDP flow considerations
    - [ ] IPv6 support

* [ ] Compute
   - [ ] Virtual Machines (VM)
    - [ ] VM SKUs and sizes
    - [ ] Managed Disks (Standard, Premium, Ultra)
    - [ ] VM Scale Sets
    - [ ] VM extensions and custom script
    - [ ] Azure Automanage
   - [ ] Platform services
    - [ ] Azure App Service (Web Apps)
     - [ ] App Service Plans
     - [ ] Deployment slots
     - [ ] Authentication/Authorization (Easy Auth)
    - [ ] Azure Functions (serverless compute)
     - [ ] Triggers and bindings
     - [ ] Durable Functions
    - [ ] Azure Batch
    - [ ] Azure Spring Apps
   - [ ] Desktop & virtualization
    - [ ] Azure Virtual Desktop (AVD)
    - [ ] Windows 365 (Cloud PC)
   - [ ] Compute optimization
    - [ ] Spot VMs
    - [ ] Reserved Instances & Savings Plans
    - [ ] Right-sizing and autoscale

* [ ] Storage
   - [ ] Storage accounts & fundamentals
    - [ ] Storage account types (General Purpose v2, BlobStorage)
    - [ ] Access tiers (Hot, Cool, Archive)
    - [ ] Replication (LRS, ZRS, GRS, RA-GRS)
    - [ ] Encryption at rest and in transit
   - [ ] Blob Storage & Data Lake
    - [ ] Blob types (Block, Page, Append)
    - [ ] Hierarchical namespace (ADLS Gen2)
    - [ ] Lifecycle management
    - [ ] Soft delete and immutability (WORM)
   - [ ] File / Disk / Queue / Table
    - [ ] Azure Files (SMB/NFS)
    - [ ] Azure Managed Disks
    - [ ] Azure Queue Storage
    - [ ] Azure Table Storage
   - [ ] Storage security & access
    - [ ] Shared Access Signatures (SAS)
    - [ ] Storage Account firewall & private endpoints
    - [ ] Immutable blob storage
   - [ ] Backup & archival
    - [ ] Azure Backup integration with Vaults
    - [ ] Archive tier usage scenarios

* [ ] Databases
   - [ ] Relational databases
    - [ ] Azure SQL Database (single, elastic pool)
    - [ ] Azure SQL Managed Instance
    - [ ] SQL on VM
    - [ ] High availability and Geo-Replication
   - [ ] Open-source relational
    - [ ] Azure Database for PostgreSQL (Flexible, Single Server)
    - [ ] Azure Database for MySQL
    - [ ] Azure Database for MariaDB
   - [ ] NoSQL & distributed databases
    - [ ] Azure Cosmos DB (Core, API for MongoDB, Cassandra, Gremlin, Table)
     - [ ] Partitioning and consistency levels
     - [ ] Global distribution
    - [ ] Azure Cache for Redis
   - [ ] Analytical & data warehousing
    - [ ] Azure Synapse Analytics (Dedicated SQL Pool, Serverless)
    - [ ] Azure Data Explorer (Kusto)
    - [ ] Azure HDInsight
   - [ ] Database management
    - [ ] Automated backups and point-in-time restore
    - [ ] High availability & failover groups
    - [ ] Elastic scale and sharding patterns

* [ ] Serverless & Integration
   - [ ] Azure Functions
    - [ ] Hosting plans (Consumption, Premium, Dedicated)
    - [ ] Proxies and bindings
    - [ ] Monitoring and scaling
   - [ ] Logic Apps
    - [ ] Connector ecosystem
    - [ ] Standard vs Consumption
    - [ ] Integration account
   - [ ] Event-driven services
    - [ ] Azure Event Grid
    - [ ] Azure Event Hubs
    - [ ] Azure Service Bus (queues, topics, subscriptions)
   - [ ] API management & gateway
    - [ ] Azure API Management (APIM)
     - [ ] Policies, products, developer portal
     - [ ] API revision and versioning
    - [ ] Azure API Gateway patterns
   - [ ] Integration patterns
    - [ ] Message queuing and pub/sub
    - [ ] Durable orchestration (Durable Functions, Logic Apps)
    - [ ] Hybrid connectors and on-prem integration

* [ ] Containers & Kubernetes (AKS)
   - [ ] Container registry & images
    - [ ] Azure Container Registry (ACR)
    - [ ] Container image best practices
   - [ ] AKS fundamentals
    - [ ] Cluster architecture (control plane, nodes)
    - [ ] Node pools (system, user, spot)
    - [ ] Networking in AKS (CNI, Kubenet)
    - [ ] Ingress controllers and load balancing
   - [ ] Advanced AKS operations
    - [ ] Cluster autoscaler
    - [ ] Virtual nodes and ACI integration
    - [ ] Pod identity and managed identities
    - [ ] RBAC in Kubernetes
   - [ ] CI/CD & GitOps
    - [ ] Helm charts
    - [ ] Flux / Argo CD integrations
    - [ ] Image scanning and signing
   - [ ] Observability & security
    - [ ] Container insights (Azure Monitor)
    - [ ] Azure Policy for AKS
    - [ ] Runtime security and NCC

* [ ] DevOps & Infrastructure as Code (IaC)
   - [ ] Source control & collaboration
    - [ ] Azure Repos
    - [ ] GitHub (repos & Actions)
    - [ ] Branching strategies (trunk, gitflow)
   - [ ] CI/CD pipelines
    - [ ] Azure Pipelines (YAML)
    - [ ] GitHub Actions workflows
    - [ ] Artifact management (Azure Artifacts)
   - [ ] IaC tooling
    - [ ] ARM templates
    - [ ] Bicep
    - [ ] Terraform (AzureRM provider)
    - [ ] Pulumi
   - [ ] Deployment patterns
    - [ ] Blue/Green deployments
    - [ ] Canary releases
    - [ ] Rolling and recreate strategies
   - [ ] DevSecOps practices
    - [ ] Scanning and SAST/DAST
    - [ ] Secrets management in pipelines
    - [ ] Policy-as-code and compliance gates

* [ ] Monitoring, Logging & Observability
   - [ ] Azure Monitor core
    - [ ] Metrics and metric alerts
    - [ ] Logs and Log Analytics workspace
    - [ ] Diagnostic settings
   - [ ] Application monitoring
    - [ ] Application Insights
    - [ ] Distributed tracing and Live Metrics
    - [ ] Dependency tracking
   - [ ] Alerts & automation
    - [ ] Alert rules and action groups
    - [ ] Autoscale rules
    - [ ] Automated remediation (runbooks, Logic Apps)
   - [ ] Visualization & reporting
    - [ ] Workbooks
    - [ ] Dashboards
    - [ ] Network Performance Monitor
   - [ ] SIEM & SOAR
    - [ ] Microsoft Sentinel playbooks
    - [ ] Data connectors and parsers

* [ ] Cost Optimization & FinOps
   - [ ] Cost fundamentals
    - [ ] Subscription and billing structure
    - [ ] Cost Management + Billing
    - [ ] Pricing calculators
   - [ ] Optimization techniques
    - [ ] Tagging for chargeback/showback
    - [ ] Rightsizing compute and storage
    - [ ] Reserved Instances & Savings Plans
    - [ ] Spot instances and preemptible workloads
   - [ ] Governance for cost
    - [ ] Budgets and cost alerts
    - [ ] Policy-driven cost controls
    - [ ] Resource lifecycle and cleanup

* [ ] Data Engineering & Analytics
   - [ ] Data ingestion & messaging
    - [ ] Azure Data Factory (pipelines, mapping data flows)
    - [ ] Event Hubs and IoT Hub for ingestion
    - [ ] Data Lake Storage Gen2
   - [ ] Data processing & transformation
    - [ ] Azure Databricks (notebooks, clusters)
    - [ ] Azure Synapse Analytics (Serverless & Dedicated)
    - [ ] Azure Data Explorer (Kusto)
   - [ ] Data modeling & serving
    - [ ] Synapse Pipelines and SQL Pools
    - [ ] Delta Lake patterns
    - [ ] Materialized views and caching
   - [ ] BI & visualization
    - [ ] Power BI integration
    - [ ] Synapse Studio
    - [ ] Lakehouse architectures

* [ ] AI, Machine Learning & Cognitive Services
   - [ ] Azure Machine Learning
    - [ ] Workspaces, compute targets, environments
    - [ ] Automated ML and model training
    - [ ] MLflow, model registry, and MLOps
   - [ ] Cognitive Services
    - [ ] Computer Vision
    - [ ] Speech (STT, TTS)
    - [ ] Language (LUIS, Text Analytics, OpenAI Service)
    - [ ] Form Recognizer
   - [ ] Responsible AI & governance
    - [ ] Model interpretability
    - [ ] Bias detection and data governance
   - [ ] Edge & on-prem inference
    - [ ] Azure Percept
    - [ ] Containerized model deployment

* [ ] Migration & Hybrid Cloud
   - [ ] Assessment & planning
    - [ ] Azure Migrate discovery and assessment
    - [ ] Server and app dependency mapping
   - [ ] Migration tools
    - [ ] Azure Site Recovery (ASR)
    - [ ] Database Migration Service (DMS)
    - [ ] Azure Database Migration Service
    - [ ] Data Box (offline data transfer)
   - [ ] Hybrid services
    - [ ] Azure Arc (servers, Kubernetes, data services)
    - [ ] Hybrid identity (AD FS, Pass-through, AD Connect)
    - [ ] Azure Stack Hub / HCI
   - [ ] Migration patterns
    - [ ] Rehost (lift-and-shift)
    - [ ] Refactor / replatform
    - [ ] Re-architect

* [ ] Enterprise Architecture & Design Patterns
   - [ ] Cloud Adoption Framework (CAF) practices
    - [ ] Strategy and planning
    - [ ] Governance and compliance
    - [ ] Landing zone designs
   - [ ] Reference architectures
    - [ ] Multi-subscription model
    - [ ] Hub-and-spoke networking
    - [ ] Zero trust architecture
   - [ ] Design considerations
    - [ ] Scalability and elasticity
    - [ ] Performance and latency
    - [ ] Security-by-design

* [ ] High Availability (HA), Disaster Recovery (DR) & Scalability
   - [ ] Resilience principles
    - [ ] Fault domains and update domains
    - [ ] Availability Zones and zone-redundant services
   - [ ] Data protection & replication
    - [ ] Geo-redundant storage
    - [ ] Database geo-replication and failover groups
   - [ ] DR planning & orchestration
    - [ ] Recovery Time Objective (RTO) and Recovery Point Objective (RPO)
    - [ ] Azure Site Recovery runbooks
    - [ ] DR drills and failover testing
   - [ ] Scalability patterns
    - [ ] Partitioning and sharding
    - [ ] Caching strategies
    - [ ] CQRS and event sourcing patterns

* [ ] Backup, Recovery & Business Continuity
   - [ ] Azure Backup
    - [ ] Recovery Services vaults
    - [ ] Backup policies (VMs, SQL, Files)
    - [ ] Instant restore and long-term retention
   - [ ] Application-consistent backups
    - [ ] SQL backups and log shipping
    - [ ] Integration with Azure Site Recovery
   - [ ] Archive and long-term retention
    - [ ] Legal hold and immutability
    - [ ] Offsite backup strategies

* [ ] Edge, IoT & Real-Time
   - [ ] IoT fundamentals
    - [ ] IoT Hub core capabilities
    - [ ] IoT Edge modules and deployment
    - [ ] Device provisioning (DPS)
   - [ ] Digital twins & time series
    - [ ] Azure Digital Twins
    - [ ] Time Series Insights
   - [ ] Edge compute
    - [ ] Azure Stack Edge
    - [ ] Azure Sphere and device security

* [ ] Developer Tools & SDKs
   - [ ] SDKs and languages
    - [ ] .NET, Java, Python, Node.js SDKs
    - [ ] REST API usage
    - [ ] OpenAPI and ARM templates
   - [ ] Tooling
    - [ ] Visual Studio & VS Code extensions
    - [ ] Azure CLI and PowerShell modules
    - [ ] Cloud Shell and Azure Pipelines tasks
   - [ ] Local development
    - [ ] Azurite emulator
    - [ ] Local Functions host
    - [ ] Containerized local services

* [ ] API, Messaging & Integration Services
   - [ ] Messaging services
    - [ ] Service Bus (queues/topics)
    - [ ] Event Hubs (ingestion)
    - [ ] Event Grid (routing)
   - [ ] Integration & workflow
    - [ ] Logic Apps connectors
    - [ ] API Management (APIM)
    - [ ] Hybrid Connections and Relay
   - [ ] Patterns & reliability
    - [ ] Retry policies and dead-lettering
    - [ ] Idempotency and exactly-once patterns

* [ ] Security Deep Dive
   - [ ] Threat protection
    - [ ] Microsoft Defender for Cloud (Compute, App, Storage)
    - [ ] Azure DDoS Protection
    - [ ] Endpoint security integrations
   - [ ] Data protection
    - [ ] BYOK and customer-managed keys
    - [ ] Transparent Data Encryption (TDE)
    - [ ] Data classification and masking
   - [ ] Network security
    - [ ] NSGs, ASGs, and firewall rules
    - [ ] Private endpoints and micro-segmentation
   - [ ] Application security
    - [ ] App Service authentication
    - [ ] API security and OAuth patterns

* [ ] Platform Management & Automation
   - [ ] Automation services
    - [ ] Azure Automation (runbooks)
    - [ ] Azure Logic Apps for automation
    - [ ] Azure Functions for automation
   - [ ] Configuration management
    - [ ] Desired State Configuration (DSC)
    - [ ] Chef / Puppet / Ansible integrations
    - [ ] Azure Policy for configuration drift
   - [ ] Management insights
    - [ ] Resource Graph queries
    - [ ] Cost Management reports
    - [ ] Advisor recommendations

* [ ] Marketplace, Support & SLAs
   - [ ] Azure Marketplace usage
    - [ ] Image and solution deployment
    - [ ] Managed applications
   - [ ] Support plans
    - [ ] Basic, Developer, Standard, Professional Direct, Premier
    - [ ] Support request best practices
   - [ ] SLAs & limits
    - [ ] Service level agreements per service
    - [ ] Quotas and resource limits

* [ ] Observability & Application Performance
   - [ ] End-to-end tracing
    - [ ] Distributed tracing with Application Insights
    - [ ] OpenTelemetry integration
   - [ ] Performance tuning
    - [ ] SQL query performance insights
    - [ ] App Service and VM profiling
   - [ ] Error and exception management
    - [ ] Crash dumps and diagnostics
    - [ ] Log retention and archiving

* [ ] Specialized & Industry Solutions
   - [ ] SAP on Azure
    - [ ] Architecture patterns and sizing
    - [ ] High availability for SAP
   - [ ] Financial services & healthcare compliance
    - [ ] Data residency and compliance controls
    - [ ] Certified architectures
   - [ ] Media & streaming
    - [ ] Azure Media Services
    - [ ] Live and on-demand workflows

* [ ] Emerging Services & Advanced Topics
   - [ ] Azure Quantum
    - [ ] Quantum computing basics and services
   - [ ] Blockchain & distributed ledger (partner solutions)
    - [ ] Azure Blockchain Workbench (ecosystem)
   - [ ] Serverless containers and edge functions
    - [ ] Container Apps
    - [ ] Functions on Kubernetes (KEDA)

* [ ] Certification & Learning Pathways
   - [ ] Fundamental certifications
    - [ ] AZ-900 (Azure Fundamentals)
    - [ ] AI-900, DP-900 basics
   - [ ] Role-based certifications
    - [ ] AZ-104 (Admin)
    - [ ] AZ-305 (Architect)
    - [ ] AZ-400 (DevOps)
    - [ ] DP-203 / DP-500 (Data)
   - [ ] Continuous learning
    - [ ] Hands-on labs and sandboxes
    - [ ] Practice tests and exam objectives



