#########################################################################################################################################################################
<#
Title   : Registry Edit
Purpose : To fix Registry vulnerability
Output  : It will fix Registry vulnerability
#>
#########################################################################################################################################################################

### Parent Script

### Required Info
[String]$SubsID=Read-Host -Prompt "Enter Subscription IDs in CSV file like e.g. D:\subs.csv "
[String]$OutputPath=Read-Host -Prompt "Enter Output Path like e.g. D:\FolderName"
[String]$ChildScriptPath=Read-Host -Prompt "Enter Child Script Path like e.g. D:\FolderName\childscript.ps1"
$Subs=gc $SubsID
###

Login-AzAccount

ForEach($Sub in $Subs)
{
Select-AzSubscription -Subscription $Sub | Out-Null
$Sub_Context_Name=(Get-AzContext).Subscription | Select -ExpandProperty Name
Write-Host "Working on Sub $Sub_Context_Name" -ForegroundColor Green


### If you dont have VMs List available
$AllAzVM = Get-AzVm -Status | where {$_.Name -match "JB" -or $_.Name -match "VPN"}


ForEach($AZVM in $AllAzVM)
{
$VM=$AZVM.Name
Write-Host "Working on VM $VM" -ForegroundColor Green
$FRG = Get-AzVM -Status | where {$_.Name -like $VM}
$rgname = $FRG.ResourceGroupName
$vmname = $FRG.Name
$location = $FRG.Location
$VMState = $FRG.PowerState


Write-Host "Working on VM $vmname" -ForegroundColor Green
 
Invoke-AzVMRunCommand -ResourceGroupName $rgname -VMName $vmname -CommandId RunPowerShellScript -ScriptPath $ChildScriptPath -Verbose -Confirm:$false >> $OutputPath\$vmname.txt

}
}

Write-Host End Of Script -ForegroundColor DarkGreen