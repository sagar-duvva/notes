#########################################################################################################################################################################
<#
Title   : Azure VM Disk Encryption
Purpose : To Get Encrypt All Azure VM Disk Except Rep Server on selected Sub
Output  : It will Encrypt All Azure VM Disk Except Rep Server on selected Sub
#>
#########################################################################################################################################################################


Login-AzAccount
Enable-AzContextAutosave | Out-Null
[String]$OutputPath=Read-Host -Prompt "Enter Output Path like e.g. D:\FolderName"
Write-Host "Selected OutPut Path $OutputPath" -ForegroundColor Yellow


$Output_path="$OutputPath\DiskEncryption.csv"


### Subscription
[String]$Sub_Id=Read-Host -Prompt "Please Enter Subscription Id"
Select-AzSubscription -Subscription $Sub_Id | Out-Null
$Sub_Context_Name=(Get-AzContext).Subscription | Select -ExpandProperty Name
$Sub_Context_Id=(Get-AzContext).Subscription | Select -ExpandProperty Id
Write-Host "You have Selected Subscription $Sub_Context_Name"

### VMs
$VMS=Get-AzVM | where {$_.Name -notlike "REP*"}
$VM_Count=$VMS.Count
$VM_Names=$VMS | Select -ExpandProperty Name
$VM_RGs=$VMS | Select -ExpandProperty ResourceGroupName
Write-Host "VMs Count $VM_Count"

### Key Vault
$Get_KV=Get-AzKeyVault
if($Get_KV.Count -gt 1){
$KVCount=$Get_KV.Count
$KVName=$Get_KV.VaultName
Write-Host "Found Multiple KeyVaults for this Subscription, KeyValuts Names $KVName " -ForegroundColor Magenta
$NewKVName=Read-Host -Prompt "Enter KeyVaultName"
$NewKV=Get-AzKeyVault -VaultName $NewKVName
$VaultName=$NewKV | Select -ExpandProperty 'VaultName'
$Vault_RG=$NewKV | Select -ExpandProperty 'ResourceGroupName'
Write-Host "You have Selected KeyValut $NewKV"
}else{
$VaultName=$Get_KV | Select -ExpandProperty 'VaultName'
$Vault_RG=$Get_KV | Select -ExpandProperty 'ResourceGroupName'
}


####################################################
### Part 1 Enabling KeyVault for Disk Encryption ###
####################################################

Set-AzKeyVaultAccessPolicy -VaultName $VaultName -ResourceGroupName $Vault_RG -EnabledForDiskEncryption -EnabledForDeployment -EnabledForTemplateDeployment
Start-Sleep -Seconds 300

#################################################################
### Part 2 Creating keys for each VM with VM name as Key name ###
#################################################################


for($i=0;$i -lt $VM_Count ; $i++)
{
$VM_Name=$VM_Names[$i]
$Add_KVK=Add-AzKeyVaultKey -Name $VM_Name -VaultName $VaultName -Destination Software  -Size 2048 
$Add_KVK | Export-Csv -NoTypeInformation -Path $Output_Path -Append
}
Start-Sleep -Seconds 300

### Adding SoftDelete to KeyVault

($resource = Get-AzResource -ResourceId (Get-AzKeyVault -VaultName $VaultName).ResourceId).Properties | Add-Member -MemberType "NoteProperty" -Name "enableSoftDelete" -Value "true"
Set-AzResource -resourceid $resource.ResourceId -Properties $resource.Properties -Force
$keyVault = Get-AzKeyVault -VaultName $VaultName -ResourceGroupName $Vault_RG;
$diskEncryptionKeyVaultUrl = $keyVault.VaultUri;
$keyVaultResourceId = $keyVault.ResourceId;

#######################################
### Part 3 Starting Disk Encryption ###
#######################################

for($i=0;$i -lt $VM_Names.count ; $i++)
{
$VM_Name=$VM_Names[$i]
if($VM_Name -notcontains "REP*"){
$keyEncryptionKeyUrl = (Get-AzKeyVaultKey -VaultName $VaultName -Name $VM_Name).Key.kid;
$VM_RG=$VM_RGs[$i]

### Defining Argurments
$Custom_Arguments=@()
$Custom_Arguments+=$VM_Name
$Custom_Arguments+=$VM_RG
$Custom_Arguments+=$Sub_Id
$Custom_Arguments+=$diskEncryptionKeyVaultUrl
$Custom_Arguments+=$keyVaultResourceId
$Custom_Arguments+=$keyEncryptionKeyUrl
$Custom_Arguments+=$keyVaultResourceId

### Job
$start_encryption_job=Start-Job -Name $VM_Name  -ArgumentList $Custom_Arguments -ScriptBlock{ 
Select-AzSubscription -Subscription $args[2]
Set-AzVMDiskEncryptionExtension -ResourceGroupName $args[1] -VMName $args[0] -DiskEncryptionKeyVaultUrl $args[3] -DiskEncryptionKeyVaultId $args[4] -KeyEncryptionKeyUrl $args[5] -KeyEncryptionKeyVaultId $args[6] -Force
} 

Write-Host "Started Disk Encryption Job $i $VM_Name"
Start-Sleep -Seconds 30
}
else{ write-host "$VM_Name VM Name Contains REP, Hence exiting without encryption" -ForegroundColor Red}


}
#####################
### END of Script ###
#####################