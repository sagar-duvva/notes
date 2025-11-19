#########################################################################################################################################################################
<#
Title   : NTFS Backward Compatibility
Purpose : To fix NTFS Backward Compatibility vulnerability
Output  : It will fix NTFS Backward Compatibility vulnerability
#>
#########################################################################################################################################################################

### Parent Script

### Required Info
[String]$Sub=Read-Host -Prompt "Enter Subscription ID: "
[String]$OutputPath=Read-Host -Prompt "Enter Output Path like e.g. D:\FolderName"
[String]$ChildScriptPath=Read-Host -Prompt "Enter Child Script Path like e.g. D:\FolderName\childscript.ps1"

###
Login-AzAccount
Select-AzSubscription -Subscription $Sub | Out-Null

### If you have VMs list available to Power ON
#$Input=Read-Host -Prompt "Input VMs List e.g. D:\Comp.txt "
#$AllAzVM = gc $Input

### If you dont have VMs List available
$AllAzVM = Get-AzVm -Status


ForEach($AZVM in $AllAzVM)
{
$VM=$AZVM.Name
Write-Host "Working on VM $VM" -ForegroundColor Green
$FRG = Get-AzVM -Status | where {$_.Name -like $VM}
$rgname = $FRG.ResourceGroupName
$vmname = $FRG.Name
$location = $FRG.Location
$VMState = $FRG.PowerState

if (($VMState -ne "VM running")){
Write-Host "Working on VM $vmname" -ForegroundColor Green
Start-AzVM -ResourceGroupName $rgname -Name $vmname -Verbose
Write-Host "Starting VM $vmname is in state $VMState" -ForegroundColor Green 
Write-Host "Will Run Invoke to VM $vmname" -ForegroundColor Green 
Invoke-AzVMRunCommand -ResourceGroupName $rgname -VMName $vmname -CommandId RunPowerShellScript -ScriptPath $ChildScriptPath -Verbose -Confirm:$false >> $OutputPath\$vmname.txt
Write-Host "Stopping VM $vmname " -ForegroundColor Red
Stop-AzVM -ResourceGroupName $rgname -Name $vmname -Force -Confirm:$false -Verbose -AsJob
}else {
Write-Host "Already VM $vmname is in $VMState" -ForegroundColor Green
Write-Host "Will Run Invoke to VM $vmname" -ForegroundColor Green
Invoke-AzVMRunCommand -ResourceGroupName $rgname -VMName $vmname -CommandId RunPowerShellScript -ScriptPath $ChildScriptPath -Verbose -Confirm:$false >> $OutputPath\$vmname.txt
}
}

$Date=Get-Date
Write-Host "Script Execution Complete $Date" -ForegroundColor Yellow
### End of the Script