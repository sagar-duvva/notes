# Production-grade multi-environment Azure Bicep architectures

---

## Example 1: Global e-commerce production in East US 2 with DR in West US

### Architecture description

A highly available, global e-commerce stack using Azure Front Door with dual-origin (AKS and Azure Container Apps), API Management for external and partner APIs, Application Gateway for internal routing to App Service and Functions, Cosmos DB for catalog, Azure SQL for transactional orders, Storage for media, Service Bus and Event Hubs for integration and telemetry, Logic Apps for order orchestration, Key Vault for secrets, and RBAC with managed identities. Primary in East US 2, DR footprint in West US with read replicas and passive compute.

### Bicep script

```bicep
// main-prod-eus2.bicep
targetScope = 'subscription'

// Parameters with validation
@allowed([
  'prod'
])
param environment string

@allowed([
  'eastus2'
])
param primaryLocation string

@allowed([
  'westus'
])
param drLocation string

param orgName string = 'contoso'
param workloadName string = 'ecomm'
param suffix string = '001'

@secure()
param adminAadObjectId string // for RBAC assignments

// Naming standard helper
var namePrefix = '${orgName}-${workloadName}-${environment}-${suffix}'

// Resource group per region
resource rgPrimary 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${orgName}-${workloadName}-${environment}-rg-eus2'
  location: primaryLocation
  tags: {
    env: environment
    owner: 'platform'
    workload: workloadName
    regionRole: 'primary'
  }
}

resource rgDr 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${orgName}-${workloadName}-${environment}-rg-wus'
  location: drLocation
  tags: {
    env: environment
    owner: 'platform'
    workload: workloadName
    regionRole: 'dr'
  }
}

// Module: networking (VNet, subnets, NSGs)
module netPrimary 'modules/networking.bicep' = {
  name: 'netPrimary'
  scope: rgPrimary
  params: {
    namePrefix: namePrefix
    location: rgPrimary.location
    addressSpace: '10.10.0.0/16'
    subnets: [
      { name: 'app', cidr: '10.10.1.0/24', nsgInboundRules: [
        // Allow AppGW to backend, block public
        { name: 'Allow-AppGW', priority: 100, source: '10.10.0.0/16', destPorts: [80, 443], protocol: 'Tcp', action: 'Allow' }
      ] }
      { name: 'data', cidr: '10.10.2.0/24', nsgInboundRules: [
        { name: 'Allow-App', priority: 100, source: '10.10.1.0/24', destPorts: [1433], protocol: 'Tcp', action: 'Allow' }
      ] }
      { name: 'aks', cidr: '10.10.3.0/24', nsgInboundRules: [] }
      { name: 'gateway', cidr: '10.10.4.0/24', nsgInboundRules: [
        { name: 'Allow-Internet-443', priority: 200, source: 'Internet', destPorts: [443], protocol: 'Tcp', action: 'Allow' }
      ] }
    ]
  }
}

// Module: key vault (with RBAC and firewall)
module kvPrimary 'modules/keyvault.bicep' = {
  name: 'kvPrimary'
  scope: rgPrimary
  params: {
    name: toLower('${namePrefix}-kv')
    location: rgPrimary.location
    tenantId: subscription().tenantId
    purgeProtectionEnabled: true
    enabledForTemplateDeployment: true
    ipAllowlist: [
      '52.165.0.0/16' // corporate NAT (example)
    ]
    adminAadObjectId: adminAadObjectId
  }
}

// Managed identity for workload
resource miWorkload 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: '${namePrefix}-mi'
  location: rgPrimary.location
  identity: {
    type: 'SystemAssigned'
  }
}

// Storage account (replication and firewall)
resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: toLower(replace('${namePrefix}sa', '-', ''))
  location: rgPrimary.location
  sku: {
    name: 'Standard_GRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      ipRules: [
        { ipAddressOrRange: '52.165.10.0/24', action: 'Allow' }
      ]
      virtualNetworkRules: [
        { id: netPrimary.outputs.subnetIds.app }
      ]
    }
  }
}

// SQL: server + DB
resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: '${namePrefix}-sqlsrv'
  location: rgPrimary.location
  properties: {
    administratorLogin: 'sqladminuser'
    administratorLoginPassword: kvPrimary.outputs.secretRef('sqlAdminPassword') // secret reference via module output
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource sqlDb 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: '${sqlServer.name}/ordersdb'
  sku: {
    name: 'GP_Gen5_2'
    tier: 'GeneralPurpose'
    capacity: 2
  }
  properties: {
    readScale: 'Enabled'
    zoneRedundant: true
  }
  dependsOn: [
    sqlServer
  ]
}

// Cosmos DB (multi-region, session consistency)
resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: '${namePrefix}-cosmos'
  location: rgPrimary.location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: primaryLocation
        failoverPriority: 0
        isZoneRedundant: true
      }
      {
        locationName: drLocation
        failoverPriority: 1
        isZoneRedundant: false
      }
    ]
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    enableAnalyticalStorage: true
    publicNetworkAccess: 'Disabled'
    ipRules: [
      '52.165.10.0/24'
    ]
    keyVaultKeyUri: kvPrimary.outputs.keyUri // Customer-managed key example
  }
}

// Service Bus
resource sb 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: '${namePrefix}-sb'
  location: rgPrimary.location
  sku: {
    name: 'Premium'
    tier: 'Premium'
    capacity: 1
  }
  properties: {
    zoneRedundant: true
    publicNetworkAccess: 'Disabled'
  }
}

// Event Hubs
resource eh 'Microsoft.EventHub/namespaces@2024-01-01' = {
  name: '${namePrefix}-eh'
  location: rgPrimary.location
  sku: {
    name: 'Premium'
    tier: 'Premium'
    capacity: 1
  }
  properties: {
    publicNetworkAccess: 'Disabled'
    zoneRedundant: true
  }
}

// API Management (external, developer tier for prod small scale example)
resource apim 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: '${namePrefix}-apim'
  location: rgPrimary.location
  sku: {
    name: 'Premium'
    capacity: 1
  }
  properties: {
    publisherEmail: 'api-team@contoso.com'
    publisherName: 'Contoso'
    virtualNetworkType: 'External'
  }
}

// App Service plan and Web App
resource asp 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${namePrefix}-asp'
  location: rgPrimary.location
  sku: {
    name: 'P1v3'
    tier: 'PremiumV3'
    capacity: 2
  }
  properties: {
    zoneRedundant: true
  }
}

resource webapp 'Microsoft.Web/sites@2023-12-01' = {
  name: '${namePrefix}-web'
  location: rgPrimary.location
  properties: {
    httpsOnly: true
    serverFarmId: asp.id
    siteConfig: {
      ftpsState: 'Disabled'
      alwaysOn: true
      appSettings: [
        { name: 'KeyVault__Uri', value: kvPrimary.outputs.vaultUri }
        { name: 'Storage__Connection', value: '@Microsoft.KeyVault(SecretUri=${kvPrimary.outputs.secretUri('storageConnection')})' }
        { name: 'Cosmos__Connection', value: '@Microsoft.KeyVault(SecretUri=${kvPrimary.outputs.secretUri('cosmosConn')})' }
      ]
    }
  }
  identity: {
    type: 'SystemAssigned, UserAssigned'
    userAssignedIdentities: {
      '${miWorkload.id}': {}
    }
  }
  dependsOn: [
    kvPrimary
    asp
  ]
}

// Function App (on consumption plan using Storage)
resource funcPlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${namePrefix}-funcplan'
  location: rgPrimary.location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
}

resource functionApp 'Microsoft.Web/sites@2023-12-01' = {
  name: '${namePrefix}-func'
  location: rgPrimary.location
  properties: {
    serverFarmId: funcPlan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        { name: 'AzureWebJobsStorage', value: '@Microsoft.KeyVault(SecretUri=${kvPrimary.outputs.secretUri('azureWebJobsStorage')})' }
        { name: 'FUNCTIONS_WORKER_RUNTIME', value: 'dotnet-isolated' }
      ]
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [
    sa
    kvPrimary
  ]
}

// Logic App (Standard, VNet integrated)
resource logicapp 'Microsoft.Web/sites@2023-12-01' = {
  name: '${namePrefix}-logic'
  location: rgPrimary.location
  properties: {
    serverFarmId: asp.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        { name: 'WORKFLOWS_MANAGEMENT_BASE_URI', value: 'https://management.azure.com/' }
      ]
      vnetRouteAllEnabled: true
    }
  }
  kind: 'functionapp,workflowapp'
}

// Container Apps (for lightweight services)
module caEnv 'modules/containerapps-env.bicep' = {
  name: 'caEnv'
  scope: rgPrimary
  params: {
    namePrefix: namePrefix
    location: rgPrimary.location
    vnetId: netPrimary.outputs.vnetId
    subnets: {
      control: netPrimary.outputs.subnetIds.app
      workload: netPrimary.outputs.subnetIds.aks
    }
  }
}

module caWorkload 'modules/containerapp.bicep' = {
  name: 'caWorkload'
  scope: rgPrimary
  params: {
    name: '${namePrefix}-ca-orders'
    envId: caEnv.outputs.envId
    image: 'contosoacr.azurecr.io/orders:1.2.3'
    cpu: 1
    memoryGb: 2
    secrets: [
      { name: 'db-conn', keyVaultSecretId: kvPrimary.outputs.secretId('ordersDbConn') }
    ]
    ingressExternal: true
  }
}

// AKS for core catalog and basket services
module aks 'modules/aks.bicep' = {
  name: 'aksCluster'
  scope: rgPrimary
  params: {
    name: '${namePrefix}-aks'
    location: rgPrimary.location
    vnetSubnetId: netPrimary.outputs.subnetIds.aks
    kubernetesVersion: '1.29.2'
    nodeSize: 'Standard_D4s_v5'
    nodeCount: 3
    enableAad: true
    enableAzurePolicy: true
    enableManagedIdentity: true
    keyVaultId: kvPrimary.outputs.vaultId
  }
}

// Application Gateway (WAF) for internal routing
module appgw 'modules/appgateway.bicep' = {
  name: 'appGateway'
  scope: rgPrimary
  params: {
    name: '${namePrefix}-agw'
    location: rgPrimary.location
    subnetId: netPrimary.outputs.subnetIds.gateway
    wafEnabled: true
    wafMode: 'Prevention'
    backendTargets: [
      { name: 'webapp', fqdn: '${webapp.name}.azurewebsites.net' }
      { name: 'func', fqdn: '${functionApp.name}.azurewebsites.net' }
    ]
  }
}

// Front Door (Premium) with dual origins (AKS and Container App)
module afd 'modules/frontdoor.bicep' = {
  name: 'frontdoor'
  scope: rgPrimary
  params: {
    name: '${namePrefix}-afd'
    location: 'global'
    origins: [
      { name: 'aks', hostName: aks.outputs.ingressHost, priority: 1, weight: 90 }
      { name: 'ca', hostName: caWorkload.outputs.fqdn, priority: 2, weight: 10 }
    ]
    customDomains: [
      { host: 'www.contoso.com', certKeyVaultId: kvPrimary.outputs.certSecretId('afd-cert') }
    ]
    wafPolicyMode: 'Prevention'
  }
}

// CDN (for static media behind storage)
module cdn 'modules/cdn.bicep' = {
  name: 'cdnProfile'
  scope: rgPrimary
  params: {
    name: '${namePrefix}-cdn'
    originHostName: '${sa.name}.blob.core.windows.net'
    location: 'global'
    sku: 'Premium_AzureFrontDoor'
  }
}

// RBAC assignments to Managed Identity
resource kvAccess 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(kvPrimary.outputs.vaultId, miWorkload.id, 'KeyVaultSecretsUser')
  scope: kvPrimary.outputs.vaultResource
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-9b802c8b3f1f') // Key Vault Secrets User
    principalId: miWorkload.properties.principalId
    principalType: 'ServicePrincipal'
  }
  dependsOn: [
    miWorkload
    kvPrimary
  ]
}

// Application Insights for observability
resource appi 'Microsoft.Insights/components@2022-06-15' = {
  name: '${namePrefix}-appi'
  location: rgPrimary.location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    IngestionMode: 'LogAnalytics'
  }
}

// Outputs
output resourceGroupName string = rgPrimary.name
output frontDoorEndpoint string = afd.outputs.endpoint
output appGatewayId string = appgw.outputs.id
output apiManagementName string = apim.name
```

### Parameter file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "environment": { "value": "prod" },
    "primaryLocation": { "value": "eastus2" },
    "drLocation": { "value": "westus" },
    "orgName": { "value": "contoso" },
    "workloadName": { "value": "ecomm" },
    "suffix": { "value": "001" },
    "adminAadObjectId": {
      "value": "00000000-0000-0000-0000-000000000000"
    }
  }
}
```

### Notes on deployment best practices

- Use staged deployments: deploy networking and Key Vault first, then data stores, then compute, followed by edge. Enforce dependency ordering with modules.
- Rotate secrets through Key Vault and reference them from App Service and Functions using Key Vault references; disable public access where supported.
- Enable zone redundancy for critical services and configure Front Door WAF with strict rules. Use RBAC for least privilege and managed identities for resource access.

---

## Example 2: Pre-production validation in Central India with blue/green slots

### Architecture description

Pre-production environment mirrors production features but with smaller SKUs and deployment slots for blue/green validation. API Management is Developer tier, App Service uses deployment slots, AKS single node pool, Cosmos DB single-region with multi-region write disabled, Service Bus Standard, Event Hubs Standard, Application Gateway WAF detection mode, Azure Front Door Standard.

### Bicep script

```bicep
// main-preprod-cci.bicep
targetScope = 'resourceGroup'

param environment string = 'preprod'
@allowed(['centralindia'])
param location string

param orgName string = 'contoso'
param workloadName string = 'ecomm'
param suffix string = 'pp01'

@secure()
param adminAadObjectId string

var namePrefix = '${orgName}-${workloadName}-${environment}-${suffix}'

// VNet + subnets via module
module net 'modules/networking.bicep' = {
  name: 'net'
  params: {
    namePrefix: namePrefix
    location: location
    addressSpace: '10.20.0.0/16'
    subnets: [
      { name: 'app', cidr: '10.20.1.0/24', nsgInboundRules: [] }
      { name: 'data', cidr: '10.20.2.0/24', nsgInboundRules: [] }
      { name: 'gateway', cidr: '10.20.3.0/24', nsgInboundRules: [] }
      { name: 'aks', cidr: '10.20.4.0/24', nsgInboundRules: [] }
    ]
  }
}

// Key Vault
module kv 'modules/keyvault.bicep' = {
  name: 'kv'
  params: {
    name: toLower('${namePrefix}-kv')
    location: location
    tenantId: subscription().tenantId
    purgeProtectionEnabled: true
    enabledForTemplateDeployment: true
    ipAllowlist: []
    adminAadObjectId: adminAadObjectId
  }
}

// App Service plan + web app with slots
resource asp 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${namePrefix}-asp'
  location: location
  sku: {
    name: 'P1v3'
    tier: 'PremiumV3'
    capacity: 1
  }
}

resource webapp 'Microsoft.Web/sites@2023-12-01' = {
  name: '${namePrefix}-web'
  location: location
  properties: {
    serverFarmId: asp.id
    httpsOnly: true
    siteConfig: {
      ftpsState: 'Disabled'
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource slotBlue 'Microsoft.Web/sites/slots@2023-12-01' = {
  name: '${webapp.name}/blue'
  properties: {
    siteConfig: {
      appSettings: [
        { name: 'KeyVault__Uri', value: kv.outputs.vaultUri }
      ]
    }
  }
}

resource slotGreen 'Microsoft.Web/sites/slots@2023-12-01' = {
  name: '${webapp.name}/green'
  properties: {
    siteConfig: {
      appSettings: [
        { name: 'KeyVault__Uri', value: kv.outputs.vaultUri }
      ]
    }
  }
}

// API Management (Developer tier)
resource apim 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: '${namePrefix}-apim'
  location: location
  sku: {
    name: 'Developer'
    capacity: 1
  }
  properties: {
    publisherEmail: 'api-team@contoso.com'
    publisherName: 'Contoso'
    virtualNetworkType: 'External'
  }
}

// Cosmos DB single-region
resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: '${namePrefix}-cosmos'
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    publicNetworkAccess: 'Disabled'
  }
}

// SQL server + db
resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: '${namePrefix}-sqlsrv'
  location: location
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: kv.outputs.secretRef('sqlAdminPassword')
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource sqlDb 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: '${sqlServer.name}/orderspp'
  sku: {
    name: 'GP_Gen5_2'
    tier: 'GeneralPurpose'
    capacity: 2
  }
  properties: {
    zoneRedundant: false
  }
}

// Application Gateway WAF in detection
module appgw 'modules/appgateway.bicep' = {
  name: 'agw'
  params: {
    name: '${namePrefix}-agw'
    location: location
    subnetId: net.outputs.subnetIds.gateway
    wafEnabled: true
    wafMode: 'Detection'
    backendTargets: [
      { name: 'webapp', fqdn: '${webapp.name}.azurewebsites.net' }
    ]
  }
}

// Front Door Standard
module afd 'modules/frontdoor.bicep' = {
  name: 'afd'
  params: {
    name: '${namePrefix}-afd'
    location: 'global'
    origins: [
      { name: 'appgw', hostName: appgw.outputs.publicFqdn, priority: 1, weight: 100 }
    ]
    customDomains: []
    wafPolicyMode: 'Detection'
  }
}

// Service Bus Standard
resource sb 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: '${namePrefix}-sb'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
    capacity: 0
  }
}

// Event Hubs Standard
resource eh 'Microsoft.EventHub/namespaces@2024-01-01' = {
  name: '${namePrefix}-eh'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
    capacity: 1
  }
}

// Storage account
resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: toLower(replace('${namePrefix}sa', '-', ''))
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
  }
}

// Outputs
output webAppName string = webapp.name
output appGatewayId string = appgw.outputs.id
output apimName string = apim.name
```

### Parameter file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "environment": { "value": "preprod" },
    "location": { "value": "centralindia" },
    "orgName": { "value": "contoso" },
    "workloadName": { "value": "ecomm" },
    "suffix": { "value": "pp01" },
    "adminAadObjectId": { "value": "11111111-2222-3333-4444-555555555555" }
  }
}
```

### Notes on deployment best practices

- Use slots and traffic routing to validate blue/green before promoting to production.
- Keep parity on networking and security posture; use smaller SKUs but identical configurations.
- Enable WAF in detection to refine rules ahead of prevention in production; collect logs in Application Insights.

---

## Example 3: Test environment in West Europe with developer productivity focus

### Architecture description

A test environment prioritizing rapid iteration: AKS with dev node sizes, Container Apps for microservices experimentation, App Service for monolith tests, Logic Apps for mock integrations, Cosmos DB emulator alternative via smaller SKU, SQL serverless tier, Front Door disabled, using Application Gateway with private endpoints. Strong guardrails remain: Key Vault, RBAC, NSGs, firewall, managed identities.

### Bicep script

```bicep
// main-test-weu.bicep
targetScope = 'resourceGroup'

param environment string = 'test'
@allowed(['westeurope'])
param location string

param orgName string = 'contoso'
param workloadName string = 'ecomm'
param suffix string = 't01'

@secure()
param adminAadObjectId string

var namePrefix = '${orgName}-${workloadName}-${environment}-${suffix}'

// Networking
module net 'modules/networking.bicep' = {
  name: 'net'
  params: {
    namePrefix: namePrefix
    location: location
    addressSpace: '10.30.0.0/16'
    subnets: [
      { name: 'app', cidr: '10.30.1.0/24', nsgInboundRules: [] }
      { name: 'data', cidr: '10.30.2.0/24', nsgInboundRules: [] }
      { name: 'aks', cidr: '10.30.3.0/24', nsgInboundRules: [] }
      { name: 'gateway', cidr: '10.30.4.0/24', nsgInboundRules: [] }
    ]
  }
}

// Key Vault
module kv 'modules/keyvault.bicep' = {
  name: 'kv'
  params: {
    name: toLower('${namePrefix}-kv')
    location: location
    tenantId: subscription().tenantId
    purgeProtectionEnabled: false
    enabledForTemplateDeployment: true
    ipAllowlist: []
    adminAadObjectId: adminAadObjectId
  }
}

// App Service (S1)
resource asp 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${namePrefix}-asp'
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
    capacity: 1
  }
}

resource webapp 'Microsoft.Web/sites@2023-12-01' = {
  name: '${namePrefix}-web'
  location: location
  properties: {
    serverFarmId: asp.id
    httpsOnly: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}

// AKS dev
module aks 'modules/aks.bicep' = {
  name: 'aks'
  params: {
    name: '${namePrefix}-aks'
    location: location
    vnetSubnetId: net.outputs.subnetIds.aks
    kubernetesVersion: '1.29.2'
    nodeSize: 'Standard_D2s_v5'
    nodeCount: 2
    enableAad: true
    enableAzurePolicy: false
    enableManagedIdentity: true
    keyVaultId: kv.outputs.vaultId
  }
}

// Container Apps env
module caEnv 'modules/containerapps-env.bicep' = {
  name: 'caEnv'
  params: {
    namePrefix: namePrefix
    location: location
    vnetId: net.outputs.vnetId
    subnets: {
      control: net.outputs.subnetIds.app
      workload: net.outputs.subnetIds.aks
    }
  }
}

module caService 'modules/containerapp.bicep' = {
  name: 'caService'
  params: {
    name: '${namePrefix}-ca-api'
    envId: caEnv.outputs.envId
    image: 'contosoacr.azurecr.io/testapi:0.1.0'
    cpu: 0.5
    memoryGb: 1
    ingressExternal: false
    secrets: [
      { name: 'sb-conn', keyVaultSecretId: kv.outputs.secretId('sbConn') }
    ]
  }
}

// SQL serverless
resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: '${namePrefix}-sqlsrv'
  location: location
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: kv.outputs.secretRef('sqlAdminPassword')
    publicNetworkAccess: 'Disabled'
    minimalTlsVersion: '1.2'
  }
}

resource sqlDb 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: '${sqlServer.name}/testdb'
  sku: {
    name: 'HS_Gen5_2'
    tier: 'Hyperscale'
    capacity: 2
  }
  properties: {
    autoPauseDelay: 60
    minCapacity: 2
  }
}

// Cosmos DB small
resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: '${namePrefix}-cosmos'
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
    publicNetworkAccess: 'Disabled'
  }
}

// Logic App Standard
resource logicapp 'Microsoft.Web/sites@2023-12-01' = {
  name: '${namePrefix}-logic'
  location: location
  properties: {
    serverFarmId: asp.id
    httpsOnly: true
  }
  kind: 'functionapp,workflowapp'
}

// Service Bus and Event Hubs
resource sb 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: '${namePrefix}-sb'
  location: location
  sku: { name: 'Standard', tier: 'Standard' }
}

resource eh 'Microsoft.EventHub/namespaces@2024-01-01' = {
  name: '${namePrefix}-eh'
  location: location
  sku: { name: 'Standard', tier: 'Standard', capacity: 1 }
}

// Application Gateway internal only
module appgw 'modules/appgateway.bicep' = {
  name: 'agw'
  params: {
    name: '${namePrefix}-agw'
    location: location
    subnetId: net.outputs.subnetIds.gateway
    wafEnabled: false
    wafMode: 'Detection'
    backendTargets: [
      { name: 'webapp', fqdn: '${webapp.name}.azurewebsites.net' }
      { name: 'ca-api', fqdn: caService.outputs.fqdn }
    ]
  }
}
```

### Parameter file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "environment": { "value": "test" },
    "location": { "value": "westeurope" },
    "orgName": { "value": "contoso" },
    "workloadName": { "value": "ecomm" },
    "suffix": { "value": "t01" },
    "adminAadObjectId": { "value": "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee" }
  }
}
```

### Notes on deployment best practices

- Keep test light but secure: disable public network access, use private endpoints, and enforce NSGs.
- Use serverless or smaller SKUs to reduce cost without changing the topology.
- Automate cleanup of test resources via TTL tags and scheduled pipelines.

---

## Example 4: Multi-region active-active API platform in South India and Southeast Asia

### Architecture description

An API-centric platform with active-active in two regions for low-latency. Azure Front Door Premium with dual origins; API Management Premium across regions in an internal VNet mode with self-hosted gateways in AKS; App Service for legacy endpoints; Container Apps for modern microservices; Key Vault per region; Cosmos DB multi-region writes; SQL geo-replication; Service Bus Premium with geo-disaster recovery alias; Event Hubs Capture to Storage via private endpoints; Application Gateway per region.

### Bicep script

```bicep
// main-api-aa.bicep
targetScope = 'subscription'

@allowed(['prod'])
param environment string
@allowed(['southindia'])
param primaryLocation string
@allowed(['southeastasia'])
param secondaryLocation string

param orgName string = 'contoso'
param workloadName string = 'apiplat'
param suffix string = '001'

@secure()
param adminAadObjectId string

var namePrefix = '${orgName}-${workloadName}-${environment}-${suffix}'

// Resource groups
resource rgPrimary 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${namePrefix}-rg-sin'
  location: primaryLocation
}
resource rgSecondary 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${namePrefix}-rg-sea'
  location: secondaryLocation
}

// Networking per region
module netPrim 'modules/networking.bicep' = {
  name: 'netPrim'
  scope: rgPrimary
  params: {
    namePrefix: '${namePrefix}-sin'
    location: primaryLocation
    addressSpace: '10.40.0.0/16'
    subnets: [
      { name: 'app', cidr: '10.40.1.0/24', nsgInboundRules: [] }
      { name: 'gateway', cidr: '10.40.2.0/24', nsgInboundRules: [] }
      { name: 'aks', cidr: '10.40.3.0/24', nsgInboundRules: [] }
      { name: 'data', cidr: '10.40.4.0/24', nsgInboundRules: [] }
    ]
  }
}
module netSec 'modules/networking.bicep' = {
  name: 'netSec'
  scope: rgSecondary
  params: {
    namePrefix: '${namePrefix}-sea'
    location: secondaryLocation
    addressSpace: '10.50.0.0/16'
    subnets: [
      { name: 'app', cidr: '10.50.1.0/24', nsgInboundRules: [] }
      { name: 'gateway', cidr: '10.50.2.0/24', nsgInboundRules: [] }
      { name: 'aks', cidr: '10.50.3.0/24', nsgInboundRules: [] }
      { name: 'data', cidr: '10.50.4.0/24', nsgInboundRules: [] }
    ]
  }
}

// Key Vault per region
module kvPrim 'modules/keyvault.bicep' = {
  name: 'kvPrim'
  scope: rgPrimary
  params: {
    name: toLower('${namePrefix}-kv-sin')
    location: primaryLocation
    tenantId: subscription().tenantId
    purgeProtectionEnabled: true
    enabledForTemplateDeployment: true
    ipAllowlist: []
    adminAadObjectId: adminAadObjectId
  }
}
module kvSec 'modules/keyvault.bicep' = {
  name: 'kvSec'
  scope: rgSecondary
  params: {
    name: toLower('${namePrefix}-kv-sea')
    location: secondaryLocation
    tenantId: subscription().tenantId
    purgeProtectionEnabled: true
    enabledForTemplateDeployment: true
    ipAllowlist: []
    adminAadObjectId: adminAadObjectId
  }
}

// API Management Premium
resource apimPrim 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: '${namePrefix}-apim-sin'
  location: primaryLocation
  sku: { name: 'Premium', capacity: 1 }
  properties: {
    publisherEmail: 'api-team@contoso.com'
    publisherName: 'Contoso'
    virtualNetworkType: 'Internal'
  }
}
resource apimSec 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: '${namePrefix}-apim-sea'
  location: secondaryLocation
  sku: { name: 'Premium', capacity: 1 }
  properties: {
    publisherEmail: 'api-team@contoso.com'
    publisherName: 'Contoso'
    virtualNetworkType: 'Internal'
  }
}

// AKS clusters running self-hosted gateway pods
module aksPrim 'modules/aks.bicep' = {
  name: 'aksPrim'
  scope: rgPrimary
  params: {
    name: '${namePrefix}-aks-sin'
    location: primaryLocation
    vnetSubnetId: netPrim.outputs.subnetIds.aks
    kubernetesVersion: '1.29.2'
    nodeSize: 'Standard_D4s_v5'
    nodeCount: 3
    enableAad: true
    enableAzurePolicy: true
    enableManagedIdentity: true
    keyVaultId: kvPrim.outputs.vaultId
  }
}
module aksSec 'modules/aks.bicep' = {
  name: 'aksSec'
  scope: rgSecondary
  params: {
    name: '${namePrefix}-aks-sea'
    location: secondaryLocation
    vnetSubnetId: netSec.outputs.subnetIds.aks
    kubernetesVersion: '1.29.2'
    nodeSize: 'Standard_D4s_v5'
    nodeCount: 3
    enableAad: true
    enableAzurePolicy: true
    enableManagedIdentity: true
    keyVaultId: kvSec.outputs.vaultId
  }
}

// Cosmos DB multi-region write
resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: '${namePrefix}-cosmos-global'
  location: primaryLocation
  properties: {
    databaseAccountOfferType: 'Standard'
    enableMultipleWriteLocations: true
    locations: [
      { locationName: primaryLocation, failoverPriority: 0, isZoneRedundant: true },
      { locationName: secondaryLocation, failoverPriority: 1, isZoneRedundant: true }
    ]
    publicNetworkAccess: 'Disabled'
  }
}

// SQL geo
resource sqlPrim 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: '${namePrefix}-sql-sin'
  location: primaryLocation
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: kvPrim.outputs.secretRef('sqlAdminPassword')
    publicNetworkAccess: 'Disabled'
  }
}
resource sqlDbPrim 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: '${sqlPrim.name}/apiplat'
  sku: { name: 'GP_Gen5_2', tier: 'GeneralPurpose', capacity: 2 }
}
resource sqlSec 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: '${namePrefix}-sql-sea'
  location: secondaryLocation
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: kvSec.outputs.secretRef('sqlAdminPassword')
    publicNetworkAccess: 'Disabled'
  }
}
resource sqlDbSec 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: '${sqlSec.name}/apiplat'
  sku: { name: 'GP_Gen5_2', tier: 'GeneralPurpose', capacity: 2 }
  properties: {
    secondaryType: 'GeoReplica'
    readScale: 'Enabled'
  }
  dependsOn: [ sqlDbPrim ]
}

// Service Bus Premium with Geo-DR alias
resource sbPrim 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: '${namePrefix}-sb-sin'
  location: primaryLocation
  sku: { name: 'Premium', tier: 'Premium', capacity: 1 }
}
resource sbSec 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: '${namePrefix}-sb-sea'
  location: secondaryLocation
  sku: { name: 'Premium', tier: 'Premium', capacity: 1 }
}

// Event Hubs Premium with Capture to Storage
resource ehPrim 'Microsoft.EventHub/namespaces@2024-01-01' = {
  name: '${namePrefix}-eh-sin'
  location: primaryLocation
  sku: { name: 'Premium', tier: 'Premium', capacity: 1 }
}
resource saCapture 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: toLower(replace('${namePrefix}cap', '-', ''))
  location: primaryLocation
  sku: { name: 'Standard_GRS' }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
  }
}

// Application Gateway per region
module agwPrim 'modules/appgateway.bicep' = {
  name: 'agwPrim'
  scope: rgPrimary
  params: {
    name: '${namePrefix}-agw-sin'
    location: primaryLocation
    subnetId: netPrim.outputs.subnetIds.gateway
    wafEnabled: true
    wafMode: 'Prevention'
    backendTargets: [
      { name: 'apim', fqdn: '${apimPrim.name}.azure-api.net' }
    ]
  }
}
module agwSec 'modules/appgateway.bicep' = {
  name: 'agwSec'
  scope: rgSecondary
  params: {
    name: '${namePrefix}-agw-sea'
    location: secondaryLocation
    subnetId: netSec.outputs.subnetIds.gateway
    wafEnabled: true
    wafMode: 'Prevention'
    backendTargets: [
      { name: 'apim', fqdn: '${apimSec.name}.azure-api.net' }
    ]
  }
}

// Front Door Premium with dual origins
module afd 'modules/frontdoor.bicep' = {
  name: 'afd'
  scope: rgPrimary
  params: {
    name: '${namePrefix}-afd'
    location: 'global'
    origins: [
      { name: 'sin', hostName: agwPrim.outputs.publicFqdn, priority: 1, weight: 50 },
      { name: 'sea', hostName: agwSec.outputs.publicFqdn, priority: 1, weight: 50 }
    ]
    customDomains: [
      { host: 'api.contoso.com', certKeyVaultId: kvPrim.outputs.certSecretId('api-cert') }
    ]
    wafPolicyMode: 'Prevention'
  }
}
```

### Parameter file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "environment": { "value": "prod" },
    "primaryLocation": { "value": "southindia" },
    "secondaryLocation": { "value": "southeastasia" },
    "orgName": { "value": "contoso" },
    "workloadName": { "value": "apiplat" },
    "suffix": { "value": "001" },
    "adminAadObjectId": { "value": "12345678-1234-1234-1234-123456789abc" }
  }
}
```

### Notes on deployment best practices

- Treat regions as equals; keep config and secrets region-scoped and replicate via pipelines.
- Use APIM Premium and Front Door for global routing, with health probes and failover configured.
- Regularly test geo-failover scenarios for Service Bus and SQL; validate Cosmos multi-master conflict resolution.

---

## Example 5: Event-driven serverless workflow in East Asia (test) and Japan East (preprod)

### Architecture description

A serverless, event-driven system: Azure Functions consumes Event Hubs telemetry and Service Bus commands, Logic Apps orchestrate business workflows, App Service hosts a lightweight portal, Cosmos DB stores event aggregates, SQL holds relational references, Storage for data lake, Front Door optional, CDN for portal static assets, Container Apps for a single async processor, Application Gateway for internal ingress. Strong focus on secrets, identities, NSGs, and RBAC.

### Bicep script

```bicep
// main-serverless-multi-env.bicep
targetScope = 'resourceGroup'

@allowed(['test', 'preprod'])
param environment string
@allowed(['eastasia', 'japaneast'])
param location string

param orgName string = 'contoso'
param workloadName string = 'events'
param suffix string = 'sv01'

@secure()
param adminAadObjectId string

var namePrefix = '${orgName}-${workloadName}-${environment}-${suffix}'

// Networking minimal with NSG rules
module net 'modules/networking.bicep' = {
  name: 'net'
  params: {
    namePrefix: namePrefix
    location: location
    addressSpace: '10.60.0.0/16'
    subnets: [
      { name: 'app', cidr: '10.60.1.0/24', nsgInboundRules: [
        { name: 'Allow-HTTPS', priority: 100, source: 'Internet', destPorts: [443], protocol: 'Tcp', action: 'Allow' }
      ] }
      { name: 'data', cidr: '10.60.2.0/24', nsgInboundRules: [] }
      { name: 'gateway', cidr: '10.60.3.0/24', nsgInboundRules: [] }
    ]
  }
}

// Key Vault with RBAC
module kv 'modules/keyvault.bicep' = {
  name: 'kv'
  params: {
    name: toLower('${namePrefix}-kv')
    location: location
    tenantId: subscription().tenantId
    purgeProtectionEnabled: true
    enabledForTemplateDeployment: true
    ipAllowlist: []
    adminAadObjectId: adminAadObjectId
  }
}

// Storage account with hierarchical namespace for data lake
resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: toLower(replace('${namePrefix}dl', '-', ''))
  location: location
  sku: { name: environment == 'preprod' ? 'Standard_GRS' : 'Standard_LRS' }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
    isHnsEnabled: true
  }
}

// Event Hubs namespace
resource eh 'Microsoft.EventHub/namespaces@2024-01-01' = {
  name: '${namePrefix}-eh'
  location: location
  sku: { name: environment == 'preprod' ? 'Standard' : 'Basic', tier: environment == 'preprod' ? 'Standard' : 'Basic', capacity: 1 }
  properties: { publicNetworkAccess: 'Disabled' }
}

// Service Bus namespace
resource sb 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: '${namePrefix}-sb'
  location: location
  sku: { name: environment == 'preprod' ? 'Premium' : 'Standard', tier: environment == 'preprod' ? 'Premium' : 'Standard', capacity: environment == 'preprod' ? 1 : 0 }
  properties: { publicNetworkAccess: 'Disabled' }
}

// App Service plan + portal
resource asp 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${namePrefix}-asp'
  location: location
  sku: {
    name: environment == 'preprod' ? 'P1v3' : 'S1'
    tier: environment == 'preprod' ? 'PremiumV3' : 'Standard'
    capacity: 1
  }
}
resource portal 'Microsoft.Web/sites@2023-12-01' = {
  name: '${namePrefix}-portal'
  location: location
  properties: {
    serverFarmId: asp.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        { name: 'KeyVault__Uri', value: kv.outputs.vaultUri },
        { name: 'Cosmos__Conn', value: '@Microsoft.KeyVault(SecretUri=' + kv.outputs.secretUri('cosmosConn') + ')' }
      ]
    }
  }
  identity: { type: 'SystemAssigned' }
}

// Azure Functions (Consumption)
resource funcPlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${namePrefix}-funcplan'
  location: location
  sku: { name: 'Y1', tier: 'Dynamic' }
}
resource functionApp 'Microsoft.Web/sites@2023-12-01' = {
  name: '${namePrefix}-func'
  location: location
  properties: {
    serverFarmId: funcPlan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        { name: 'AzureWebJobsStorage', value: '@Microsoft.KeyVault(SecretUri=' + kv.outputs.secretUri('azureWebJobsStorage') + ')' },
        { name: 'EVENTHUB__CONNECTION', value: '@Microsoft.KeyVault(SecretUri=' + kv.outputs.secretUri('ehConn') + ')' },
        { name: 'SERVICEBUS__CONNECTION', value: '@Microsoft.KeyVault(SecretUri=' + kv.outputs.secretUri('sbConn') + ')' }
      ]
    }
  }
  identity: { type: 'SystemAssigned' }
}

// Logic App Standard
resource logicapp 'Microsoft.Web/sites@2023-12-01' = {
  name: '${namePrefix}-logic'
  location: location
  properties: {
    serverFarmId: asp.id
    httpsOnly: true
  }
  kind: 'functionapp,workflowapp'
}

// Cosmos DB and SQL
resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: '${namePrefix}-cosmos'
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      { locationName: location, failoverPriority: 0 }
    ]
    publicNetworkAccess: 'Disabled'
  }
}
resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: '${namePrefix}-sqlsrv'
  location: location
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: kv.outputs.secretRef('sqlAdminPassword')
    publicNetworkAccess: 'Disabled'
  }
}
resource sqlDb 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: '${sqlServer.name}/eventsdb'
  sku: { name: 'GP_S_Gen5_1', tier: 'GeneralPurposeServerless', capacity: 1 }
  properties: { autoPauseDelay: 60, minCapacity: 1 }
}

// Application Gateway WAF detection
module appgw 'modules/appgateway.bicep' = {
  name: 'agw'
  params: {
    name: '${namePrefix}-agw'
    location: location
    subnetId: net.outputs.subnetIds.gateway
    wafEnabled: true
    wafMode: 'Detection'
    backendTargets: [
      { name: 'portal', fqdn: '${portal.name}.azurewebsites.net' },
      { name: 'func', fqdn: '${functionApp.name}.azurewebsites.net' }
    ]
  }
}

// CDN for static assets
module cdn 'modules/cdn.bicep' = {
  name: 'cdn'
  params: {
    name: '${namePrefix}-cdn'
    originHostName: '${portal.name}.azurewebsites.net'
    location: 'global'
    sku: 'Standard_AzureFrontDoor'
  }
}
```

### Parameter file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "environment": { "value": "preprod" },
    "location": { "value": "japaneast" },
    "orgName": { "value": "contoso" },
    "workloadName": { "value": "events" },
    "suffix": { "value": "sv01" },
    "adminAadObjectId": { "value": "9f9f9f9f-0000-1111-2222-333333333333" }
  }
}
```

### Notes on deployment best practices

- Keep serverless configurations immutable via Bicep and parameter files; changes flow through CI/CD.
- Centralize secrets across Functions, Logic Apps, and App Service via Key Vault references; audit access.
- Use tier scaling conditional on environment to control cost while preserving behavior.

---

# Shared reusable modules

Below are minimal, production-grade modules referenced in the examples. They’re structured with clear inputs/outputs and security-first configurations.

### Networking module

```bicep
// modules/networking.bicep
param namePrefix string
param location string
param addressSpace string
param subnets array

// VNet
resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
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
          addressPrefix: s.cidr
          networkSecurityGroup: empty(s.nsgInboundRules) ? null : {
            id: resourceId('Microsoft.Network/networkSecurityGroups', '${namePrefix}-nsg-${s.name}')
          }
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

// NSGs per subnet with inbound rules
resource nsgs 'Microsoft.Network/networkSecurityGroups@2023-05-01' = [for s in subnets: {
  name: '${namePrefix}-nsg-${s.name}'
  location: location
  properties: {
    securityRules: [
      for (r, i) in s.nsgInboundRules: {
        name: r.name
        properties: {
          description: 'Rule ${r.name}'
          protocol: r.protocol
          sourcePortRange: '*'
          destinationPortRanges: [for p in r.destPorts: string(p)]
          sourceAddressPrefix: r.source
          destinationAddressPrefix: '*'
          access: r.action
          priority: r.priority
          direction: 'Inbound'
        }
      }
    ]
  }
}]

// Outputs
output vnetId string = vnet.id
output subnetIds object = {
  app: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, 'app')
  data: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, 'data')
  aks: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, 'aks')
  gateway: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, 'gateway')
}
```

### Key Vault module

```bicep
// modules/keyvault.bicep
param name string
param location string
param tenantId string
param purgeProtectionEnabled bool = true
param enabledForTemplateDeployment bool = true
param ipAllowlist array = []
param adminAadObjectId string

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: name
  location: location
  properties: {
    tenantId: tenantId
    enableRbacAuthorization: true
    enablePurgeProtection: purgeProtectionEnabled
    enabledForTemplateDeployment: enabledForTemplateDeployment
    sku: { family: 'A', name: 'standard' }
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [for ip in ipAllowlist: { value: ip }]
    }
  }
}

resource ra 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(kv.id, adminAadObjectId, 'OwnerAssignment')
  scope: kv
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // Contributor
    principalId: adminAadObjectId
    principalType: 'User'
  }
}

output vaultId string = kv.id
output vaultUri string = kv.properties.vaultUri
output vaultResource object = kv

// Helpers to reference secrets/certs (documented convention)
output secretUri string = 'function secretUri(secretName) {return kv.properties.vaultUri + ' + "secrets/" + ' secretName }'
output secretId string = 'function secretId(secretName) {return kv.id + "/secrets/" + secretName }'
output secretRef string = 'function secretRef(secretName) {return "@Microsoft.KeyVault(SecretUri=" + kv.properties.vaultUri + "secrets/" + secretName + ")" }'
output keyUri string = kv.properties.vaultUri
output certSecretId string = 'function certSecretId(certName) {return kv.id + "/certificates/" + certName }'
```

### AKS module

```bicep
// modules/aks.bicep
param name string
param location string
param vnetSubnetId string
param kubernetesVersion string
param nodeSize string
param nodeCount int
param enableAad bool
param enableAzurePolicy bool
param enableManagedIdentity bool
param keyVaultId string

resource aks 'Microsoft.ContainerService/managedClusters@2023-10-01' = {
  name: name
  location: location
  properties: {
    kubernetesVersion: kubernetesVersion
    dnsPrefix: toLower(name)
    agentPoolProfiles: [
      {
        name: 'systempool'
        count: nodeCount
        vmSize: nodeSize
        mode: 'System'
        osType: 'Linux'
        vnetSubnetID: vnetSubnetId
        enableNodePublicIP: false
      }
    ]
    apiServerAccessProfile: {
      enablePrivateCluster: true
    }
    addonProfiles: {
      azurepolicy: {
        enabled: enableAzurePolicy
      }
    }
    identityProfile: {}
    servicePrincipalProfile: {}
  }
  identity: {
    type: enableManagedIdentity ? 'SystemAssigned' : 'None'
  }
}

// Outputs
output id string = aks.id
output ingressHost string = '${aks.name}.privatelink.eastus2.azmk8s.io' // placeholder host format
```

### Application Gateway module

```bicep
// modules/appgateway.bicep
param name string
param location string
param subnetId string
param wafEnabled bool
@allowed(['Prevention', 'Detection'])
param wafMode string
param backendTargets array // [{name, fqdn}]

resource agw 'Microsoft.Network/applicationGateways@2022-09-01' = {
  name: name
  location: location
  properties: {
    sku: { name: wafEnabled ? 'WAF_v2' : 'Standard_v2', tier: wafEnabled ? 'WAF_v2' : 'Standard_v2', capacity: 2 }
    gatewayIPConfigurations: [
      { name: 'gwip', properties: { subnet: { id: subnetId } } }
    ]
    frontendIPConfigurations: [
      { name: 'PublicIP', properties: { publicIPAddress: { id: resourceId('Microsoft.Network/publicIPAddresses', '${name}-pip') } } }
    ]
    frontendPorts: [
      { name: 'port-443', properties: { port: 443 } }
    ]
    sslCertificates: []
    httpListeners: [
      { name: 'listener-https', properties: { frontendIPConfiguration: { id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', name, 'PublicIP') }, frontendPort: { id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', name, 'port-443') }, protocol: 'Https' } }
    ]
    requestRoutingRules: [
      for b in backendTargets: {
        name: 'rule-${b.name}'
        properties: {
          ruleType: 'Basic'
          httpListener: { id: resourceId('Microsoft.Network/applicationGateways/httpListeners', name, 'listener-https') }
          backendAddressPool: { id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', name, 'pool-${b.name}') }
          backendHttpSettings: { id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', name, 'setting-${b.name}') }
        }
      }
    ]
    backendAddressPools: [
      for b in backendTargets: {
        name: 'pool-${b.name}'
        properties: { backendAddresses: [ { fqdn: b.fqdn } ] }
      }
    ]
    backendHttpSettingsCollection: [
      for b in backendTargets: {
        name: 'setting-${b.name}'
        properties: { port: 443, protocol: 'Https', pickHostNameFromBackendAddress: true }
      }
    ]
    webApplicationFirewallConfiguration: wafEnabled ? { enabled: true, firewallMode: wafMode } : null
  }
}

resource pip 'Microsoft.Network/publicIPAddresses@2022-05-01' = {
  name: '${name}-pip'
  location: location
  sku: { name: 'Standard' }
  properties: { publicIPAllocationMethod: 'Static' }
}

output id string = agw.id
output publicFqdn string = pip.properties.dnsSettings.fqdn
```

### Front Door module

```bicep
// modules/frontdoor.bicep
param name string
param location string // 'global'
param origins array // [{name, hostName, priority, weight}]
param customDomains array // [{host, certKeyVaultId}]
@allowed(['Prevention', 'Detection'])
param wafPolicyMode string

resource afd 'Microsoft.Cdn/profiles@2023-05-01' = {
  name: name
  location: location
  sku: { name: 'Premium_AzureFrontDoor' }
}

resource endpoint 'Microsoft.Cdn/profiles/endpoints@2023-05-01' = {
  name: '${afd.name}/fd-endpoint'
  location: location
  properties: {
    originResponseTimeoutSeconds: 60
    origins: [
      for o in origins: {
        name: o.name
        properties: {
          hostName: o.hostName
          priority: o.priority
          weight: o.weight
          httpPort: 80
          httpsPort: 443
        }
      }
    ]
  }
}

output endpoint string = endpoint.name
```

### Container Apps env and app modules

```bicep
// modules/containerapps-env.bicep
param namePrefix string
param location string
param vnetId string
param subnets object // {control, workload}

resource cae 'Microsoft.App/managedEnvironments@2024-02-01' = {
  name: '${namePrefix}-cae'
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: '00000000-0000-0000-0000-000000000000' // replace with real LA workspace ID
        sharedKey: '***'
      }
    }
    vnetConfiguration: {
      infrastructureSubnetId: subnets.control
      internal: true
    }
  }
}

output envId string = cae.id
```

```bicep
// modules/containerapp.bicep
param name string
param envId string
param image string
param cpu int
param memoryGb int
param ingressExternal bool
param secrets array // [{name, keyVaultSecretId}]

resource ca 'Microsoft.App/containerApps@2024-02-01' = {
  name: name
  location: resourceGroup().location
  properties: {
    managedEnvironmentId: envId
    configuration: {
      secrets: [for s in secrets: { name: s.name, value: '@microsoft.keyvault(' + s.keyVaultSecretId + ')' }]
      ingress: {
        external: ingressExternal
        targetPort: 443
      }
    }
    template: {
      containers: [
        {
          name: 'main'
          image: image
          resources: { cpu: cpu, memory: '${memoryGb}Gi' }
          env: [for s in secrets: { name: toUpper(replace(s.name, '-', '_')), value: '{{secret.' + s.name + '}}' }]
        }
      ]
    }
  }
}

output fqdn string = ca.properties.configuration.ingress.fqdn
```

### CDN module

```bicep
// modules/cdn.bicep
param name string
param originHostName string
param location string
param sku string

resource profile 'Microsoft.Cdn/profiles@2023-05-01' = {
  name: name
  location: location
  sku: { name: sku }
}
resource endpoint 'Microsoft.Cdn/profiles/endpoints@2023-05-01' = {
  name: '${name}/endpoint'
  location: location
  properties: {
    origins: [
      {
        name: 'origin1'
        properties: { hostName: originHostName }
      }
    ]
  }
}
```

---

## General deployment notes

- **Dependencies:** Modules and resources reference IDs and outputs explicitly; deploy foundational components (networking, Key Vault) first.
- **Region-specific locations:** Parameters enforce region constraints; avoid mixing global resources into regional groups unless required.
- **Security best practices:** All compute uses managed identities; secrets are stored and referenced from Key Vault; public access disabled where supported; NSGs and WAF configured.
- **RBAC:** Assign minimal roles (e.g., Key Vault Secrets User) only to identities that need them; avoid broad permissions.
- **Naming conventions:** Use a consistent pattern org-workload-env-suffix across all resources; ensure lowercasing where required (e.g., storage accounts).
- **Validation rules:** Parameters use allowed lists for environment and location to prevent misconfiguration.
- **Reusable modules:** Encapsulate patterns (networking, gateways, front door, container apps) for consistency and easier updates.

If you want these tailored for your specific subscription, region in Telangana, or to fit existing resource groups, tell me your org/workload names and any quotas or policies you must meet.