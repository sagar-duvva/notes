#Sample Script to Authenticate to CSI and add Secret for tenant

if (!(Get-InstalledModule adal.ps -ErrorAction SilentlyContinue)) 
{ 
    Install-Package -Name adal.ps 
}

$authority = "https://login.windows.net/common/oauth2/authorize" 
$redirectUri = "https://login.live.com/oauth20_desktop.srf"

#PROD
$resourceUrl = "https://microsoft.com/5c0ba7b1-60bb-4b68-b7e8-1fe485344d5a"
$clientId = "a6f3096b-d6ba-4b0c-b73b-b5b0e358285b"
$baseUri = "https://msft-cssp-prod.azurewebsites.net/api/v3"

#UAT
#$resourceUrl = "https://microsoft.com/60798afa-9459-421f-864f-93faf9956111"
#$clientId = "606a4358-ad5a-42fc-b178-603ed0e1740a"
#$baseUri = "https://msft-csi-uat.azurewebsites.net/api/v3"

#DEV
#$resourceUrl = "https://microsoft.com/2505d69d-c321-44f1-a6ac-4ea35139d37a"
#$clientId = "47bbabd4-d4ef-4842-922f-835839488d7c"
#$baseUri = "https://msft-cssp-dev.azurewebsites.net/api/v3"

$authResponse = Get-ADALToken -Resource $resourceUrl -ClientId $clientId -RedirectUri $redirectUri -Authority $authority -PromptBehavior:Always 

$header = @{}
$header.Add("Authorization", $authResponse.CreateAuthorizationHeader())

$tenantid = Read-Host "Enter Tenant ID"

#Retreive all projects associated with TenantId usin V3 csi api
$projectUri = [System.String]::Format("{0}/Customer/{1}/Project", $baseUri, $tenantid)
$projectApiResponse = try
{
    Invoke-RestMethod -Method GET -Uri $projectUri -ContentType 'application/json' -Headers $header
} 
catch
{
    Write-Host $_ 
    exit
}

Write-Output "ASSOCIATED PROJECTS FOR THIS TENANT:"$tenantid
$projectSelected = $projectApiResponse | Select-Object -Property ProjectName, ProjectIdentifier, ProjectType | Out-GridView -Title "Select Project"  -OutputMode Single
$projectID = $projectSelected.ProjectIdentifier

#Retreive vault for selected Project using csi v3 api
$vaultUri = [System.String]::Format("{0}/Customer/{1}/Project/{2}/Vault", $baseUri, $tenantid, $projectID)
$vaultApiresponse = try
{
    Invoke-RestMethod -Method GET -Uri $vaultUri -ContentType 'application/json' -Headers $header
} 
catch
{
    Write-Host $_ 
    exit
}

$migrationType = $projectSelected.ProjectType  
$credentialType = Read-Host "Enter Credential Type"

#Retreiving all valid credential subtypes for entered credential type
$credentialTypeUri = [System.String]::Format("{0}/admin/MigrationTypeCredentialMappings?migrationType={1}&credentialType={2}", $baseUri, $migrationType, $credentialType)
$credentialTypeApiResponse = try
{
    Invoke-RestMethod -Method GET -Uri $credentialTypeUri -ContentType 'application/json' -Headers $header
} 
catch
{
    Write-Host $_ 
    exit-
}

$credSubtype = $credentialTypeApiResponse | Out-GridView -Title "Select Credential SubType"  -OutputMode Single
$credentialTypeidentifier = $credSubtype.CredentialTypeIdentifier

$secretName = Read-Host "Enter User Name" 
$secretValue = Read-Host "Enter Password"
$secretComment = Read-Host "Enter Comments"
$vaultId = $vaultApiresponse[0].VaultIdentifier

$secretCreatebody = @" 
{
  "ProjectIdentifier": "$projectID",
  "VaultIdentifier": "$vaultId",
  "credentialTypeIdentifier": "$credentialTypeidentifier",
  "SecretName": "$secretName",
  "SecretValue": "$secretValue",
  "Comments": "$secretComment",
  "SourceApplication": "CSI"
}
"@

#Post api call for adding secret to corresponding vault
$secretPostUri = [System.String]::Format("{0}/Customer/{1}/Project/{2}/Vault/{3}/Secret", $baseUri, $tenantid, $projectID, $vaultId)
$secretApiresponse = try
{
    Invoke-RestMethod -Method Post -Uri $secretPostUri -ContentType 'application/json' -Headers $header -Body $secretCreatebody
    Write-Host "Secret Created"
} 
catch
{
    Write-Host "Error Creating Secret" $_ 
    exit
}

