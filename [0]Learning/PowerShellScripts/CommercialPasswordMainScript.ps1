#########################################################################################################################################################################
<#
Title   : Commercial Password Expiry
Purpose : To generate of password expiry details
Output  : It create system log in every DC with mentioned Event ID
#>
#########################################################################################################################################################################

### Parent Script

### Child Script Location
[String]$ChildScriptPath=Read-Host -Prompt "Enter Child Script Path like e.g. D:\FolderName\childscript.ps1"
Write-Host "Selected ChildScriptPath Path $ChildScriptPath" -ForegroundColor Yellow

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
$VM = Get-AzVM | Where-Object {$_.Name -Like "DC*"} | select "ResourceGroupName","Name"
$vmname = $VM.Name
$rgname = $VM.ResourceGroupName
### Executes Script on DC VM on select sub using RunPowerShellScript
### Scritp 2 path "Path\To\Script2.ps1"
if($vmname.Count -gt 0){
Invoke-AzVMRunCommand -ResourceGroupName $rgname -VMName $vmname -CommandId RunPowerShellScript -ScriptPath $ChildScriptPath -AsJob -Verbose -ErrorAction SilentlyContinue
}else
{
Write-Host "No VMs are available in Sub $Sub_Name and its Id is $Sub_Id" -ForegroundColor Red
}


}

### End of the Parent Script