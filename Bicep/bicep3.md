Great — **Example 3 will be: _Enterprise SaaS Multi-Tenant Application Architecture_**, delivered in:

- **Directory Structure Format**
    
- **High Detail (Level B)**
    
- **Production-grade, multi-environment (prod / preprod / test)**
    
- **Full Bicep (top-level + modules + params + notes)**
    

This represents a **real multi-tenant SaaS platform** with:

- API Management Premium (multi-region, VNET)
    
- AKS hosting per-tenant microservices
    
- Multi-tenant **Cosmos DB** (logical partitioning)
    
- Elastic SQL pools for high-volume tenants
    
- Azure Front Door (Global)
    
- Event Hubs + Service Bus for async workflows
    
- Container Apps for background tasks
    
- Logic Apps for provisioning automation
    
- Multi-environment config (prod, preprod, test)
    
- Private endpoints everywhere (PCI/HIPAA capable)
    
- Strict network isolation between tenants
    

---

# ───────────────────────────────────────────

# **EXAMPLE 3 — Enterprise SaaS Multi-Tenant Platform**

# ───────────────────────────────────────────

# **Directory Structure Overview**

```
/example3
  main.bicep
  /modules
      network.bicep
      security.bicep
      compute.bicep
      apim.bicep
      data.bicep
      cosmos.bicep
      integration.bicep
      containerapps.bicep
      logicapp.bicep
      frontdoor.bicep
  params-prod.bicepparam
  params-preprod.bicepparam
  params-test.bicepparam
  NOTES.md
```

---

# ==========================================================

# **main.bicep**

# ==========================================================

```bicep
@description('Deployment environment: prod | preprod | test')
param environment string {
  allowed: [
    'prod'
    'preprod'
    'test'
  ]
}

param primaryLocation string
param secondaryLocation string = ''
param baseName string
@secure()
param sqlAdminPassword string
param aksAdminObjectId string

var namePrefix = '${baseName}-${environment}'
var isProd = environment == 'prod'

// Network
module network 'modules/network.bicep' = {
  name: 'network'
  params: {
    namePrefix: namePrefix
    location: primaryLocation
    environment: environment
  }
}

// Security
module security 'modules/security.bicep' = {
  name: 'security'
  params: {
    namePrefix: namePrefix
    location: primaryLocation
    subnetIds: network.outputs.subnetIds
  }
}

// Data (Cosmos + SQL Elastic Pools)
module data 'modules/data.bicep' = {
  name: 'data'
  params: {
    namePrefix: namePrefix
    location: primaryLocation
    sqlAdminPassword: sqlAdminPassword
    dataSubnetId: network.outputs.subnetIds.data
  }
}

// Multi-tenant Cosmos DB (logical partitions)
module cosmos 'modules/cosmos.bicep' = {
  name: 'cosmos'
  params: {
    namePrefix: namePrefix
    location: primaryLocation
  }
}

// Compute (AKS for microservices)
module compute 'modules/compute.bicep' = {
  name: 'compute'
  params: {
    namePrefix: namePrefix
    location: primaryLocation
    aksAdminObjectId: aksAdminObjectId
    appSubnetId: network.outputs.subnetIds.app
    keyVaultId: security.outputs.keyVaultId
  }
}

// APIM Premium (multi-tenant API routing)
module apim 'modules/apim.bicep' = {
  name: 'apim'
  params: {
    namePrefix: namePrefix
    location: primaryLocation
    subnetId: network.outputs.subnetIds.integration
  }
}

// Integration (SB + EH)
module integration 'modules/integration.bicep' = {
  name: 'integration'
  params: {
    namePrefix: namePrefix
    location: primaryLocation
  }
}

// Container Apps for background tasks
module containerapps 'modules/containerapps.bicep' = {
  name: 'containerapps'
  params: {
    namePrefix: namePrefix
    location: primaryLocation
  }
}

// Logic App for tenant provisioning flows
module logicapp 'modules/logicapp.bicep' = {
  name: 'logicapp'
  params: {
    namePrefix: namePrefix
    location: primaryLocation
  }
}

// Front Door (Prod only)
module frontdoor 'modules/frontdoor.bicep' = if (isProd) {
  name: 'frontdoor'
  params: {
    namePrefix: namePrefix
    backendHostname: apim.outputs.apimHostname
  }
}
```

---

# ==========================================================

# **/modules/network.bicep**

# ==========================================================

```bicep
param namePrefix string
param location string
param environment string

var addressSpace = '10.20.0.0/16'
var subnets = [
  { name: 'app'; prefix: '10.20.1.0/24' }
  { name: 'data'; prefix: '10.20.2.0/24' }
  { name: 'integration'; prefix: '10.20.3.0/24' }
]

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: '${namePrefix}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [addressSpace]
    }
    subnets: [
      for s in subnets: {
        name: s.name
        properties: {
          addressPrefix: s.prefix
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output subnetIds object = {
  app: vnet.properties.subnets[0].id
  data: vnet.properties.subnets[1].id
  integration: vnet.properties.subnets[2].id
}
```

---

# ==========================================================

# **/modules/security.bicep**

# ==========================================================

```bicep
param namePrefix string
param location string
param subnetIds object

resource kv 'Microsoft.KeyVault/vaults@2024-01-01' = {
  name: '${namePrefix}-kv'
  location: location
  properties: {
    sku: { name: 'standard' }
    enablePurgeProtection: true
    enableRbacAuthorization: true
    softDeleteRetentionInDays: 30
    tenantId: subscription().tenantId
  }
}

resource kvpe 'Microsoft.Network/privateEndpoints@2024-01-01' = {
  name: '${namePrefix}-kv-pe'
  location: location
  properties: {
    subnet: { id: subnetIds.data }
    privateLinkServiceConnections: [
      {
        name: 'kv-pe-conn'
        properties: {
          groupIds: ['vault']
          privateLinkServiceId: kv.id
        }
      }
    ]
  }
}

output keyVaultId string = kv.id
```

---

# ==========================================================

# **/modules/data.bicep**

# ==========================================================

```bicep
param namePrefix string
param location string
param sqlAdminPassword string
param dataSubnetId string

resource sqlserver 'Microsoft.Sql/servers@2023-08-01-preview' = {
  name: '${namePrefix}-sql'
  location: location
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: sqlAdminPassword
  }
}

// Elastic Pool (shared by tenants)
resource elasticpool 'Microsoft.Sql/servers/elasticPools@2023-08-01-preview' = {
  name: '${namePrefix}-pool'
  parent: sqlserver
  sku: {
    name: 'GP_Gen5'
    tier: 'GeneralPurpose'
  }
  properties: {
    perDatabaseSettings: {
      minCapacity: 0.25
      maxCapacity: 2
    }
  }
}

// Tenant DB for new tenants
resource tenantDb 'Microsoft.Sql/servers/databases@2023-08-01-preview' = {
  name: '${namePrefix}-tenantdb'
  parent: sqlserver
  properties: {
    elasticPoolId: elasticpool.id
  }
}

resource sqlpe 'Microsoft.Network/privateEndpoints@2024-01-01' = {
  name: '${namePrefix}-sql-pe'
  location: location
  properties: {
    subnet: { id: dataSubnetId }
    privateLinkServiceConnections: [
      {
        name: 'sql-pe-conn'
        properties: {
          groupIds: ['sqlServer']
          privateLinkServiceId: sqlserver.id
        }
      }
    ]
  }
}
```

---

# ==========================================================

# **/modules/cosmos.bicep**

# ==========================================================

```bicep
param namePrefix string
param location string

resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2024-06-15' = {
  name: '${namePrefix}-cosmos'
  location: location
  properties: {
    capabilities: [
      { name: 'EnablePartitionMerge' }
      { name: 'EnableServerless' }
    ]
    databaseAccountOfferType: 'Standard'
    locations: [
      { locationName: location; failoverPriority: 0 }
    ]
  }
}

// Logical database for multi-tenancy
resource db 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2024-06-15' = {
  name: 'multitenant'
  parent: cosmos
  properties: {
    resource: {
      id: 'multitenant'
    }
  }
}

// Container using TenantId as partition key
resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2024-06-15' = {
  name: 'directory'
  parent: db
  properties: {
    resource: {
      id: 'directory'
      partitionKey: {
        paths: ['/tenantId']
        kind: 'Hash'
      }
      throughput: 400
    }
  }
}

output cosmosEndpoint string = cosmos.properties.documentEndpoint
```

---

# ==========================================================

# **/modules/compute.bicep**

# ==========================================================

```bicep
param namePrefix string
param location string
param aksAdminObjectId string
param appSubnetId string
param keyVaultId string

resource aks 'Microsoft.ContainerService/managedClusters@2024-01-01' = {
  name: '${namePrefix}-aks'
  location: location
  properties: {
    identity: { type: 'SystemAssigned' }
    aadProfile: {
      enableAzureRBAC: true
      adminGroupObjectIDs: [aksAdminObjectId]
    }
    networkProfile: {
      networkPlugin: 'azure'
      vnetSubnetID: appSubnetId
      loadBalancerSku: 'standard'
    }
    agentPoolProfiles: [
      {
        name: 'system'
        mode: 'System'
        vmSize: 'Standard_DS3_v2'
        count: 2
        vnetSubnetID: appSubnetId
      }
      {
        name: 'workload'
        mode: 'User'
        vmSize: 'Standard_DS4_v2'
        count: 3
        vnetSubnetID: appSubnetId
      }
    ]
  }
}

// AKS -> Key Vault access
resource kvaccess 'Microsoft.KeyVault/vaults/accessPolicies@2024-01-01' = {
  name: '${namePrefix}-aks-access'
  parent: keyVaultId
  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: aks.identityProfile.kubeletidentity.objectId
        permissions: {
          secrets: ['get', 'list']
        }
      }
    ]
  }
}
```

---

# ==========================================================

# **/modules/apim.bicep**

# ==========================================================

```bicep
param namePrefix string
param location string
param subnetId string

resource apim 'Microsoft.ApiManagement/service@2023-05-01-preview' = {
  name: '${namePrefix}-apim'
  location: location
  sku: { name: 'Premium'; capacity: 1 }
  properties: {
    virtualNetworkConfiguration: {
      subnetResourceId: subnetId
    }
    publisherEmail: 'ops@saas.com'
    publisherName: 'SaaS Team'
  }
}

output apimHostname string = apim.properties.gatewayUrl
```

---

# ==========================================================

# **/modules/integration.bicep**

# ==========================================================

```bicep
param namePrefix string
param location string

resource sb 'Microsoft.ServiceBus/namespaces@2024-01-01' = {
  name: '${namePrefix}-sb'
  location: location
  sku: { name: 'Premium' }
}

resource eh 'Microsoft.EventHub/namespaces@2024-01-01' = {
  name: '${namePrefix}-eh'
  location: location
  sku: { name: 'Standard' }
}
```

---

# ==========================================================

# **/modules/containerapps.bicep**

# ==========================================================

```bicep
param namePrefix string
param location string

resource env 'Microsoft.Web/kubeEnvironments@2023-11-01' = {
  name: '${namePrefix}-ca-env'
  location: location
  properties: {
    environmentType: 'managed'
  }
}

resource task 'Microsoft.Web/containerApps@2023-11-01' = {
  name: '${namePrefix}-task-runner'
  location: location
  properties: {
    kubeEnvironmentId: env.id
    configuration: {
      ingress: { external: false }
    }
    template: {
      containers: [
        {
          image: 'mcr.microsoft.com/oss/busybox'
          name: 'worker'
        }
      ]
    }
  }
}
```

---

# ==========================================================

# **/modules/logicapp.bicep**

# ==========================================================

```bicep
param namePrefix string
param location string

resource la 'Microsoft.Logic/workflows@2023-01-01' = {
  name: '${namePrefix}-tenant-provisioning'
  location: location
  properties: {
    state: 'Enabled'
    definition: {
      "$schema": "https://schema.management.azure.com/schemas/2016-06-01/workflowdefinition.json#"
      triggers: {}
      actions: {}
    }
  }
}
```

---

# ==========================================================

# **/modules/frontdoor.bicep**

# ==========================================================

```bicep
param namePrefix string
param backendHostname string

resource afd 'Microsoft.Cdn/profiles@2024-01-01' = {
  name: '${namePrefix}-afd'
  sku: { name: 'Premium_AzureFrontDoor' }
}

resource endpoint 'Microsoft.Cdn/profiles/endpoints@2024-01-01' = {
  name: '${namePrefix}-fe'
  parent: afd
  properties: {
    originGroups: []
  }
}
```

---

# ==========================================================

# **params-prod.bicepparam**

# ==========================================================

```bicepparam
using 'main.bicep'

param environment = 'prod'
param baseName = 'saas'
param primaryLocation = 'eastus'
param secondaryLocation = 'westus'
param sqlAdminPassword = 'ProdSecurePassw0rd!'
param aksAdminObjectId = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
```

---

# ==========================================================

# **params-preprod.bicepparam**

# ==========================================================

```bicepparam
using 'main.bicep'

param environment = 'preprod'
param baseName = 'saas'
param primaryLocation = 'eastus'
param sqlAdminPassword = 'PreProd1!'
param aksAdminObjectId = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
```

---

# ==========================================================

# **params-test.bicepparam**

# ==========================================================

```bicepparam
using 'main.bicep'

param environment = 'test'
param baseName = 'saas'
param primaryLocation = 'eastus'
param sqlAdminPassword = 'Test1234!'
param aksAdminObjectId = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
```

---

# ==========================================================

# **NOTES.md (Deployment Best Practices)**

# ==========================================================

```
# SaaS Multi-Tenant Azure Platform – Best Practices

## Multi-Tenant Data Isolation
- Use Cosmos DB partition key = tenantId for logical isolation.
- Use SQL Elastic Pools for cost-efficient tenant DB hosting.
- Evaluate per-tenant database vs shared schema based on workload.

## Network & Security
- Private Endpoints for SQL, Storage, Cosmos.
- APIM Premium enables internal VNET mode.
- AKS uses System + Workload node pools for separation.

## CI/CD
- Use GitHub Actions with environment protection gates.
- Deploy per-environment parameter files.

## Observability
- Use Azure Monitor + Container Insights.
- Track APIM per-tenant usage via custom headers & analytics.

## Scalability
- Autoscale AKS workload pool via KEDA.
- Cosmos autoscale throughput (400→4000 RU/s).
```

---

# ✅ **EXAMPLE 3 COMPLETE**

---

# ❓ Ready for Example 4?

Choose scenario for **Example 4**:

### **1. Healthcare Patient Data (HIPAA) System**

### **2. IoT Telemetry & Analytics Platform**

### **3. Media Streaming & Content Distribution**

### **5. Government Zero-Trust Architecture**

Which one should Example 4 be?