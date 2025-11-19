#########################################################################################################################################################################
<#
Title   : OMS Agent Validation
Purpose : To check OMS Agent Status for all the subscriptions
Output  : It will generate an excel sheet with all subscription/workload vms OMS Agent Status details
#>
#########################################################################################################################################################################

 
 
[String]$OutputPath=Read-Host -Prompt "Enter Output Path like e.g. D:\FolderName"

Start-Transcript -path "$OutputPath\OMS_Transcript.txt" -append
import-module Az.Security

Connect-AzAccount
$Sub_Id = Get-AzSubscription | ? {$_.State -like "Enabled"} | Select -ExpandProperty Id
$Sub_Count = $Sub_Id.Count
Write-Host "Subs count is $Sub_Count " -ForegroundColor Yellow


for($j=0 ; $j -lt $Sub_Id.count ; $j++){
$ProcessingCount1=$j+1
$RemainingCount1=$Sub_Id.count-$ProcessingCount1
Write-Host "Processing Subscription $ProcessingCount1 | Remaining Subscriptions $RemainingCount1" -ForegroundColor Yellow
$Select_Sub=Select-AzSubscription $Sub_Id[$j]
Start-Job -Name $Sub_Id[$j] -ScriptBlock {
$Sub_Context_Name=(Get-AzContext).Subscription | Select -ExpandProperty Name
$Sub_Context_Id=(Get-AzContext).Subscription | Select -ExpandProperty Id

$VM_Details=Get-AzVM
$VM_Name=$VM_Details | Select -ExpandProperty Name
$RG=$VM_Details | Select -ExpandProperty ResourceGroupName
$Extension_PS= 1..$VM_Name.count | foreach { $false }
$PublicSettings= 1..$VM_Name.count | foreach { $false }
$Workspace_Id= 1..$VM_Name.count | foreach { $false }
$Workspace_config= 1..$VM_Name.count | foreach { $false }
$PS_config= 1..$VM_Name.count | foreach { $false }
$WorkspaceId_Policy=Get-AzSecurityWorkspaceSetting | Select -ExpandProperty WorkspaceId
$Workspace_policy_Config="Other Workspace"
if($WorkspaceId_Policy -eq "/subscriptions/7c8d3bff-f442-40e7-a2ef-bd67ddd8462b/resourcegroups/centralomsresourcegroup/providers/microsoft.operationalinsights/workspaces/centralomsworkspace")
{
$Workspace_policy_Config="CentralOMSWorkspace"
}

for($i=0;$i -lt $VM_Name.count ; $i++)
{
$ProcessingCount2=$i+1
$RemainingCount2=$VM_Name.count-$ProcessingCount2
Write-Host "Processing VM $ProcessingCount2 | Remaining VMs $RemainingCount2" -ForegroundColor Cyan


$Extension_PS[$i]=Get-AzVMExtension -ResourceGroupName $RG[$i] -VMName $VM_Name[$i] -Name 'MicrosoftMonitoringAgent' -ErrorAction SilentlyContinue| Select -ExpandProperty 'ProvisioningState' 
$PublicSettings=Get-AzVMExtension -ResourceGroupName $RG[$i] -VMName $VM_Name[$i] -Name 'MicrosoftMonitoringAgent' -ErrorAction SilentlyContinue| Select -ExpandProperty 'PublicSettings' 
if(!$PublicSettings)
{
$Extension_PS[$i]=Get-AzVMExtension -ResourceGroupName $RG[$i] -VMName $VM_Name[$i] -Name 'Microsoft.EnterpriseCloud.Monitoring' -ErrorAction SilentlyContinue| Select -ExpandProperty 'ProvisioningState' 
$PublicSettings=Get-AzVMExtension -ResourceGroupName $RG[$i] -VMName $VM_Name[$i] -Name 'Microsoft.EnterpriseCloud.Monitoring' -ErrorAction SilentlyContinue| Select -ExpandProperty 'PublicSettings' 
}                                        
$Public_Settings=$PublicSettings| ConvertFrom-Json
$Workspace_Id[$i]=$Public_Settings | Select -ExpandProperty workspaceId

if($Extension_PS[$i] -eq 'Succeeded')
{
$PS_config[$i]='Succeeded'
}
else
{
$PS_config[$i]='Failed'
}

if($Workspace_Id[$i] -eq '2a6981d8-1296-442a-901d-d95e9c25439f')
{
$Workspace_config[$i]='CentralOMSWorkspace'
}
else
{
$Workspace_config[$i]='Other Workspace'
}
}


$combinedResults=@()
for($i=0;$i -lt $VM_Name.count ; $i++)
{
$tabName = "OMS Validation Results"
$table = New-Object system.Data.DataTable “$tabName”
$col1 = New-Object system.Data.DataColumn Subscription_Name,([string])
$col2 = New-Object system.Data.DataColumn Subscription_Id,([string])
$col3 = New-Object system.Data.DataColumn VM_Name,([string])
$col4 = New-Object system.Data.DataColumn Workspace_Config,([string])
$col5 = New-Object system.Data.DataColumn Policy_Config,([string])
$col6 = New-Object system.Data.DataColumn Provisioning_Status ,([string])
$table.columns.add($col1)
$table.columns.add($col2)
$table.columns.add($col3)
$table.columns.add($col4)
$table.columns.add($col5)
$table.columns.add($col6)
$row = $table.NewRow()
$row.Subscription_Name = $Sub_Context_Name
$row.Subscription_Id = $Sub_Context_Id
$row.VM_Name = $VM_Name[$i]
$row.Workspace_Config = $Workspace_config[$i]
$row.Policy_Config = $Workspace_policy_Config
$row.Provisioning_Status = $PS_config[$i]
$table.Rows.Add($row)
$combinedResults += $table
}



$combinedResults | Export-CSV -Append -NoTypeInformation -Path "$OutputPath\OMS_Validation.csv"

}  | Format-List -Property InstanceId,Id,Name,ChildJobs,PSBeginTime,State  
} 

$Date=Get-Date
Write-Host "Execution Complete $Date"  -ForegroundColor Yellow

Stop-Transcript

### End of the Script