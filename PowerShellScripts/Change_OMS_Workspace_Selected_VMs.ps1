#########################################################################################################################################################################
<#
Title   : Change OMS Workspace
Purpose : To Change OMS Workspace
Output  : It will Change OMS Workspace
#>
#########################################################################################################################################################################


Login-AzAccount

#Details to get new OMSWorkSpace ID & Key
Select-AzSubscription -Subscription 7c8d3bff-f442-40e7-a2ef-bd67ddd8462b | Out-Null
$workspaceName = "CentralOMSWorkSpace"
$OMSresourcegroup = "centralomsresourcegroup"
$workspace = Get-AzOperationalInsightsWorkspace -Name $workspaceName -ResourceGroupName $OMSresourcegroup
$workspaceId = $workspace.CustomerId
$workspaceKey = (Get-AzOperationalInsightsWorkspaceSharedKeys -ResourceGroupName $workspace.ResourceGroupName -Name $workspace.Name).PrimarySharedKey

### OutPut Path
[String]$OutputPath=Read-Host -Prompt "Enter Output Path like e.g. D:\FolderName"
Write-Host "Selected OutPut Path $OutputPath" -ForegroundColor Yellow

#Provide the Subscription details that needs to rehomed to new OMSWorkspace, replace the SubscriptionName
[String]$Sub=Read-Host -Prompt "Enter Subscription ID: "
Select-AzSubscription -Subscription $Sub

### If you have VMs list available to Power ON
[String]$Inputfilepath=Read-Host -Prompt "Input VMs List e.g. D:\Comp.txt "
$AllAzVM = gc $Inputfilepath
Write-Host "Selected InPut Path $Inputfilepath" -ForegroundColor Yellow
$AllAzVM

### If you dont have VMs List available
$VMs=$AllAzVM.Name
ForEach($VM in $VMs)
{
$FRG = $AllAzVM | where {$_.Name -like $VM}


$rgname = $FRG.ResourceGroupName
$vmname = $FRG.Name
$location = $FRG.Location
$VMState = $FRG.PowerState

Write-Host "Working on VM $vmname" -ForegroundColor Yellow

Get-AzVMExtension -VM $vmname -ResourceGroupName $rgname -Name 'MicrosoftMonitoringAgent' | Select VMName,ResourceGroupName,Name,ExtensionType,Publisher,TypeHandlerVersion,ProvisioningState,PublicSettings | Export-Csv $OutputPath\MMACurrent.csv -Append -NoTypeInformation
Remove-AzVMExtension -ResourceGroupName $rgname -VMName $vmname -Name 'MicrosoftMonitoringAgent' -Force
Set-AzVMExtension -ResourceGroupName $rgname -VMName $vmname -Name 'Microsoft.EnterpriseCloud.Monitoring' -Publisher 'Microsoft.EnterpriseCloud.Monitoring' -ExtensionType 'MicrosoftMonitoringAgent' -TypeHandlerVersion '1.0' -Location $location -SettingString "{'workspaceId': '$workspaceId'}" -ProtectedSettingString "{'workspaceKey': '$workspaceKey'}"
Get-AzVMExtension -ResourceGroupName $rgname -VMName $vmname -Name 'Microsoft.EnterpriseCloud.Monitoring'| Select VMName,ResourceGroupName,Name,ExtensionType,Publisher,TypeHandlerVersion,ProvisioningState,PublicSettings | Export-Csv $OutputPath\MECMNew.csv -Append -NoTypeInformation

}
