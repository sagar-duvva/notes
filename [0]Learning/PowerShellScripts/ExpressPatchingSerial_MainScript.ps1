#########################################################################################################################################################################
<#
Title   : Express Patching
Purpose : To Express Patch All VMs in All Subs
Output  : It Express Patch All VMs in All Subs
#>
#########################################################################################################################################################################

### Parent Script

### Child Script Location
$ChildScriptPath=Read-Host -Prompt "Enter Child Script Path like e.g. D:\FolderName\childscript.ps1"

### Connects to Azure
Connect-AzAccount

### Collects all Subs details
$SubId = Get-AzSubscription | where {$_.State -Like "Enabled*"} | Select -ExpandProperty Id


### Select Single sub at a time from above collected sub data
for($j=0 ; $j -lt $SubId.count ; $j++)
{
$ProcessingCount1=$j+1
$RemainingCount1=$SubId.count-$ProcessingCount1
Write-Host "Processing Subscription $ProcessingCount1 | Remaining Subscriptions $RemainingCount1" -ForegroundColor Yellow
$Select_Sub=Select-AzSubscription $SubId[$j] | Out-Null
$Sub_Name=(Get-AzContext).Subscription | Select -ExpandProperty Name
$Sub_Id=(Get-AzContext).Subscription | Select -ExpandProperty Id
Write-Host "Working on Sub $Sub_Name and its Id is $Sub_Id" -ForegroundColor Yellow
#####
$VM_Details = Get-AzVM 
$count=$VM_Details.Count

if($count -gt 0)
{
$VM_Name=$VM_Details | Select -ExpandProperty Name
$VM_RG=$VM_Details | Select -ExpandProperty ResourceGroupName
$VM_OSType=$VM_Details.StorageProfile.OsDisk.OsType

for($i=0;$i -lt $count ; $i++){
$vmname=$VM_Name[$i]
$rgname=$VM_RG[$i]
$ostype=$VM_OSType[$i]

if($ostype -match "Windows"){

Invoke-AzVMRunCommand -ResourceGroupName $rgname -VMName $vmname -CommandId RunPowerShellScript -ScriptPath $ChildScriptPath -AsJob -Verbose -ErrorAction SilentlyContinue

}else{Write-Host "VM $vmname is not Windows VM, Skiping it" -ForegroundColor Red}
}
}Else{Write-Host "No VMs are available in Sub $Sub_Name and its Id is $Sub_Id" -ForegroundColor Red}


}
$Date=Get-Date
Write-Host "Script Execution Complete $Date" -ForegroundColor Yellow
### End of the Parent Script


