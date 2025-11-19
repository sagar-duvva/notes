#########################################################################################################################################################################
<#
Title   : Power ON Azure VMs
Purpose : To Start All/Selected VMs which are in powered off state
Output  : It will Start All/Selected VMs which are in powered off state
#>
#########################################################################################################################################################################

Login-AzAccount

[String]$Sub=Read-Host -Prompt "Enter Subscription ID: "
Select-AzSubscription -Subscription $Sub


### If you dont have VMs List available
$AllAzVM = Get-AzVm -Status

ForEach($AZVM in $AllAzVM)
{
$VM=$AZVM.Name
$FRG = Get-AzVM -Status | where {$_.Name -like $VM}
$rgname = $FRG.ResourceGroupName
$vmname = $FRG.Name
$location = $FRG.Location
$VMState = $FRG.PowerState

if (($VMState -ne "VM running")){
Write-Host "Turning ON VM $vmname" -ForegroundColor Green
Start-AzVM -ResourceGroupName $rgname -Name $vmname
Write-Host "Powered ON VM $vmname" -ForegroundColor Green         
}else {
Write-Host "Already VM $vmname is in $VMState state" -ForegroundColor Green
}
}