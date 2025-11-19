#########################################################################################################################################################################
<#
Title   : KeyVault Update
Purpose : To Remove KeyVault Secret
Output  : It will Remove KeyVault Secret
#>
#########################################################################################################################################################################

[String]$Test=Read-Host "Waring: This script is used to Remove/Delete select Keyvault secret. If you want proceed please Type 'Yes' or else type 'Exit' to exit" 
if($Test -contains "Yes"){Write-Host "Selected Yes" -ForegroundColor Yellow

Connect-AzAccount

[String]$Sub=Read-Host -Prompt "Enter Subscription ID: "
Select-AzSubscription -Subscription $Sub

$VMs=Get-AzVM

$vaultName = Read-Host -Prompt "Please Enter Key Vault Name"
$vmName = Read-Host -Prompt "Please Enter VM Name"


$VM=$VMs | ? {$_.Name -like $vmName}
Write-Host Working on $VM


$Get_KV=Get-AzKeyVault
$KVName=$Get_KV.VaultName

if($KVName -contains $vaultName){


$VMN=$VM.Name
$ResourceGroup = $VM.ResourceGroupName

$vaultId = (Get-AzKeyVault -VaultName $vaultName).ResourceId
$vm = Get-AzRmVM -ResourceGroupName $ResourceGroup -Name $VMN
Remove-AzVMSecret -VM $vm  -SourceVaultId $vaultId
Update-AzVM -ResourceGroupName $ResourceGroup -VM $vm 

}else{Write-Host "Key Vault Name $vaultName is either incorrect or unavilable, please check and retry again"}



}
Elseif($Test -contains "Exit")
{Write-Host "Selected Exit" -ForegroundColor Yellow}
Else{Write-Host "Typed wrong/Unknown keyword '$Test', please re-run the script and use 'Yes' or 'Exit' Keyword" -ForegroundColor Red}





