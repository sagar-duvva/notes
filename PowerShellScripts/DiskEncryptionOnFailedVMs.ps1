#########################################################################################################################################################################
<#
Title   : Azure VM Disk Encryption on Failed VMs
Purpose : To Encrypt Failed Azure VM Disk
Output  : It will Encrypt Failed Azure VM Disk
#>
#########################################################################################################################################################################



Login-AzAccount
Enable-AzContextAutosave | Out-Null

### Subscription
[String]$Sub_Id=Read-Host -Prompt "Please Enter Subscription Id (Single Subs Id Only)"
Select-AzSubscription -Subscription $Sub_Id | Out-Null
$Sub_Context_Name=(Get-AzContext).Subscription | Select -ExpandProperty Name
$Sub_Context_Id=(Get-AzContext).Subscription | Select -ExpandProperty Id
Write-Host "You have Selected Subscription $Sub_Context_Name"


### Key Vault
$Get_KV=Get-AzKeyVault
$KVCount=$Get_KV.Count
if($KVCount -gt 1){
$KVName=$Get_KV.VaultName
$KVPrnt=$KVName | fl
Write-Host "Found Multiple KeyVaults for this Subscription, KeyValuts Names $KVPrnt " -ForegroundColor Magenta
$NewKVName=Read-Host -Prompt "Enter KeyVaultName"
$NewKV=Get-AzKeyVault -VaultName $NewKVName
$VaultName=$NewKV | Select -ExpandProperty 'VaultName'
$Vault_RG=$NewKV | Select -ExpandProperty 'ResourceGroupName'
Write-Host "You have Selected KeyValut $VaultName"
}else{
$VaultName=$Get_KV | Select -ExpandProperty 'VaultName'
$Vault_RG=$Get_KV | Select -ExpandProperty 'ResourceGroupName'
}


### VMs
$VMNamefile=Read-Host "Please Enter Failed VMs text file path"
$VMnames=gc $VMNamefile
$VM_Count=$vmnames.count
Write-Host "Select VMs"
$VM_Count
$VMnames
for($i=0; $i -lt $VM_Count; $i++){
$VMS=Get-AzVM -Name $VMnames[$i]
$VM_Name=$VMS | Select -ExpandProperty Name
$VM_RG=$VMS | Select -ExpandProperty ResourceGroupName

Write-Host " Working on VM $VM_Name "


### Disk Encryption Status
$Get_Encryption_Status=Get-AzVMDiskEncryptionStatus -VMName $VM_Name -ResourceGroupName $VM_RG
$OsVolumeEncrypted= $Get_Encryption_Status| Select -ExpandProperty OsVolumeEncrypted
$DataVolumesEncrypted= $Get_Encryption_Status| Select -ExpandProperty DataVolumesEncrypted
$OsVolumeEncryptionSettings= $Get_Encryption_Status| Select -ExpandProperty OsVolumeEncryptionSettings
$ProgressMessage= $Get_Encryption_Status| Select -ExpandProperty ProgressMessage

### Extension Status
$Extension=Get-AzVMExtension -ResourceGroupName $VM_RG -VMName $VM_Name -Name AzureDiskEncryption | select VMName, Name, ProvisioningState
$ExtensionProvision=$Extension.ProvisioningState


if($OsVolumeEncrypted -notcontains "Encrypted"){
Write-Host " $VM_Name Encryption Status $OsVolumeEncrypted " -ForegroundColor Red
### Extension Removal
if($ExtensionProvision -notcontains "Succeeded"){
Write-Host " $VM_Name Extension Status $Extension " -ForegroundColor Red
Write-Host " Removing AzureDiskEncryption Extension on $VM_Name " -ForegroundColor Red
Remove-AzVMExtension -ResourceGroupName $VM_RG -VMName $VM_Name -Name AzureDiskEncryption -Force


Write-Host "Finished Removal of Extension, Proceeding with Disk Encryption" -ForegroundColor Yellow

$NewExtensionStatus=Get-AzVMExtension -ResourceGroupName $VM_RG -VMName $VM_Name -Name AzureDiskEncryption | select VMName, Name, ProvisioningState
Write-Host "$VM_Name Extenstion Status $NewExtensionStatus" -ForegroundColor Yellow

### Key Valut data retrival
$keyVault = Get-AzKeyVault -VaultName $VaultName -ResourceGroupName $Vault_RG;
$diskEncryptionKeyVaultUrl = $keyVault.VaultUri;
$keyVaultResourceId = $keyVault.ResourceId;
$keyEncryptionKeyUrl = (Get-AzKeyVaultKey -VaultName $VaultName -Name $VM_Name).Key.kid;


### Starting Disk Encryption ###

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
Write-Host "Staring Encryption Job on $VM_Name" -ForegroundColor Yellow
$start_encryption_job=Start-Job -Name $VM_Name  -ArgumentList $Custom_Arguments -ScriptBlock{ 
Select-AzSubscription -Subscription $args[2]
Set-AzVMDiskEncryptionExtension -ResourceGroupName $args[1] -VMName $args[0] -DiskEncryptionKeyVaultUrl $args[3] -DiskEncryptionKeyVaultId $args[4] -KeyEncryptionKeyUrl $args[5] -KeyEncryptionKeyVaultId $args[6] -Force

Write-Host "Started Disk Encryption Job $VM_Name" -ForegroundColor Yellow
Start-Sleep -Seconds 30
}

}else{
$Extension| fl
}

}else{
Write-Host "Disk Encyption Status for $VM_Name" -ForegroundColor Cyan
$Get_Encryption_Status|fl
Write-Host "VM Extension Status for $VM_Name" -ForegroundColor Cyan
$Extension | fl
}
}
### End of the Script ###