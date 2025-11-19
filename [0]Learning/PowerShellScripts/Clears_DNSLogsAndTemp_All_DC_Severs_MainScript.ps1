#########################################################################################################################################################################
<#
Title   : Temp Files & DNS Logs Deletion
Purpose : To Clear Temp Files and DNS Logs from All DC Servers
Output  : It will Clear Temp Files and DNS Logs from All DC Servers
#>
#########################################################################################################################################################################

### Parent Script


### Child Script Location
[String]$ChildScriptPath=Read-Host -Prompt "Enter Child Script Path like e.g. D:\FolderName\childscript.ps1"
Write-Host "Selected ChildScriptPath Path $ChildScriptPath" -ForegroundColor Yellow

### Connects to Azure
Connect-AzAccount

### Collects all Subs details
$Subs = Get-AzSubscription | ? {$_.State -like "Enabled"} | Select -ExpandProperty Id

$count = $Subs.count
foreach($Sub in $Subs)
{
Write-Host $count "Subscriptions are pending"
$SubscriptionId = $Sub.ID
Write-Host "Script executing on" $Sub.Name
Select-AzSubscription -Subscription $SubscriptionId | Out-Null
$VM = Get-AzVM | Where-Object {$_.Name -Like "DC*"} | select "ResourceGroupName","Name" 


if($VM.count -ne 0)
{
 $vmname = $VM.Name
 $rgname = $VM.ResourceGroupName
 Invoke-AzVMRunCommand -ResourceGroupName $rgname -VMName $vmname -CommandId RunPowerShellScript -ScriptPath $ChildScriptPath -Verbose -ErrorAction SilentlyContinue -AsJob
 
 }else{Write-Host "No VMs are available in Sub $Sub_Name and its Id is $Sub_Id" -ForegroundColor Red}
 
 $count = $count-1;

}